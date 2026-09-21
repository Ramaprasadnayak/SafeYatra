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
  double usrscore = 0;
  double latitude = 0.0;
  double longitude = 0.0;

  Future<void> initializeHome(BuildContext context,VoidCallback onUpdate) async {
    await loadCachedLocation(onUpdate);
    if (!context.mounted) return;
    await getLocationDetails(context, onUpdate);
    if (!context.mounted) return;
    await loadDetails(context, onUpdate);
    if (!context.mounted) return;
    await predictDetails(context, onUpdate);
  }
  Future<void> predictDetails(BuildContext context,VoidCallback onUpdate) async {
    final data = await predict(context, usrdistrict);
    if (data == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("safety_label", data["risk_label"]);
    usrscore = (data["safety_score"] as num).toDouble();
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
      latitude = position.latitude;
      longitude = position.longitude;

      if (!context.mounted) return;

      List<Placemark> places = await geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (places.isEmpty) {
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
          if (!context.mounted) return;
          district = await getDistrict(
            context,
            position.latitude,
            position.longitude,
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
      // Silently fail - location updates are not critical to app function
      // User will see cached/default location values
    }
  }
}