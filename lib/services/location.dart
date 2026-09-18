import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> isConnected() async {
  final result = await Connectivity().checkConnectivity();
  return result.contains(ConnectivityResult.wifi) ||
         result.contains(ConnectivityResult.mobile) ||
         result.contains(ConnectivityResult.ethernet);
}

Future<Position> getCurrentPosition() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();

    // Check again after returning from settings
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception('Please enable location services.');
    }
  }

  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.denied) {
    throw Exception('Location permission denied.');
  }

  if (permission == LocationPermission.deniedForever) {
    await Geolocator.openAppSettings();

    throw Exception(
      'Location permission permanently denied. '
      'Please enable it from Settings.',
    );
  }

  return await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
    ),
  );
}


Future<String?> getDistrict(
  double latitude,
  double longitude,
) async {
  try {
    String apiUrl = dotenv.env["apiUrl"]!;

    final response = await http.post(
      Uri.parse("http://$apiUrl/getdistrict/"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "latitude": latitude,
        "longitude": longitude,
      }),
    );

    print("District API status: ${response.statusCode}");
    print("District API response: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 &&
        data["message"] == "retrived district") {
      print("District received: ${data["district"]}");

      return data["district"];
    }

    print(
      "District API failed: "
      "${data["detail"] ?? data["message"] ?? "Something went wrong"}",
    );

    return null;
  } catch (e) {
    print("District API error: $e");
    return null;
  }
}