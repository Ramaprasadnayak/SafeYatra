import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:safeyatra/services/get_detail.dart';
import 'package:safeyatra/services/get_prediction.dart';
import 'package:safeyatra/services/location.dart';

class HomeController {
  final Geocoding geocoding = Geocoding();
  String usrname = "Dear Explorer";
  String usrcity = "your city";
  String usrdistrict = "your district";
  String usrstate = "your state";
  String usrnation = "your nation";
  double usrscore = 0,latitude=13.0688,longitude= 74.9936;

  Future<void> initializeHome(BuildContext context,VoidCallback onUpdate) async {
    await loadCachedLocation(onUpdate);
    await getLocationDetails(context, onUpdate);
    await loadDetails(context, onUpdate);
    await predictDetails(context, onUpdate);
  }
  Future<void> predictDetails(BuildContext context,VoidCallback onUpdate) async {
    final data = await predict(context, usrdistrict);
    if (data == null) return;
    usrscore = (data["safety_score"] as num).toDouble();
    print("District: ${data["district_name"]}");
    print("State: ${data["state_name"]}");
    print("Risk Score: ${data["safety_score"]}");
    print("Risk Label: ${data["risk_label"]}");
    onUpdate();
  }
  Future<void> loadDetails(BuildContext context,VoidCallback onUpdate) async {
    final info = await getUserInfo(context);
    final prefs = await SharedPreferences.getInstance();
    if (info == null) return;
    usrname = prefs.getString("usrname") ?? info["username"];
    await prefs.setString("usrname", usrname);
    onUpdate();
  }

  Future<void> loadCachedLocation(VoidCallback onUpdate) async {
    final saved = await getLocation();
    usrcity = saved[0] ?? usrcity;
    usrdistrict = saved[1] ?? usrdistrict;
    usrstate = saved[2] ?? usrstate;
    usrnation = saved[3] ?? usrnation;
    onUpdate();
  }
  Future<void> getLocationDetails(BuildContext context,VoidCallback onUpdate) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      Position position = await getCurrentPosition();
      // latitude=position.latitude;
      // longitude=position.longitude;
      List<Placemark> places = await geocoding.placemarkFromCoordinates(
        13.0688,
        74.9936,
        // position.latitude,
        // position.longitude,
      );
      if (places.isEmpty) {
        print("No location information found");
        return;
      }
      await prefs.setDouble("latitude", position.latitude);
      await prefs.setDouble("longitude", position.longitude);
      Placemark place = places.first;
      final currentCity = place.locality ?? "";
      final districtSyncedCity =prefs.getString("districtSyncedCity") ?? "";
      String? district =prefs.getString("district") ?? "your district";
      if (currentCity != districtSyncedCity) {
        if (await isConnected()) {
          district = await getDistrict(
            context,
            13.0688,
            74.9936,
            // position.latitude,
            // position.longitude,
          );
          if (district != null && district.isNotEmpty) {
            await prefs.setString(
              "districtSyncedCity",
              currentCity,
            );
          }
        }
      }
      await prefs.setString("city", currentCity);
      await prefs.setString("district", district ?? "");
      await prefs.setString("state",place.administrativeArea ?? "");
      await prefs.setString("nation",place.country ?? "");
      usrcity = currentCity;
      usrdistrict = district ?? usrdistrict;
      usrstate = place.administrativeArea ?? usrstate;
      usrnation = place.country ?? usrnation;
      onUpdate();
    } catch (e) {
      print("Location error: $e");
    }
  }
}