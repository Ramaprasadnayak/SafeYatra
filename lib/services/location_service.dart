import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:safeyatra/services/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:safeyatra/services/get_detail.dart';

class LocationService {
  Future<Map<String, dynamic>> getLocationDetails() async {
    final prefs = await SharedPreferences.getInstance();

    Position position = await getCurrentPosition();

    final places = await geocoding.placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (places.isEmpty) {
      throw Exception("No location information found");
    }

    final place = places.first;

    final currentCity = place.locality ?? "";

    String district =
        prefs.getString("district") ?? "your district";

    final districtSyncedCity =
        prefs.getString("districtSyncedCity") ?? "";

    if (currentCity != districtSyncedCity) {
      if (await isConnected()) {
        final newDistrict = await getDistrict(
          position.latitude,
          position.longitude,
        );

        if (newDistrict != null && newDistrict.isNotEmpty) {
          district = newDistrict;
          await prefs.setString(
            "districtSyncedCity",
            currentCity,
          );
        }
      }
    }

    await prefs.setDouble("latitude", position.latitude);
    await prefs.setDouble("longitude", position.longitude);

    await prefs.setString("city", currentCity);
    await prefs.setString("district", district);
    await prefs.setString(
      "state",
      place.administrativeArea ?? "",
    );
    await prefs.setString(
      "nation",
      place.country ?? "",
    );

    return {
      "city": currentCity,
      "district": district,
      "state": place.administrativeArea ?? "",
      "nation": place.country ?? "",
      "latitude": position.latitude,
      "longitude": position.longitude,
    };
  }

  Future<List<String?>> getCachedLocation() async {
    final prefs = await SharedPreferences.getInstance();

    return [
      prefs.getString("city"),
      prefs.getString("district"),
      prefs.getString("state"),
      prefs.getString("nation"),
    ];
  }
}