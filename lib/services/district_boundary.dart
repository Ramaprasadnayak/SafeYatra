import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

Future<List<List<LatLng>>?> getDistrictBoundaries(String distcode,BuildContext context) async {
  try {
    String apiUrl = dotenv.env["apiUrl"]!;
    final response = await http.get(
      Uri.parse(
        "http://$apiUrl/api/districts/$distcode/coordinates",
      ),
      headers: {
        "Content-Type": "application/json",
      },
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data["message"] == "retrived boundary successfully") {
      final List<dynamic> polygons = data["polygons"];
      return polygons.map<List<LatLng>>((polygon) {
        return (polygon as List).map<LatLng>((point) {
          return LatLng(
            (point["lat"] as num).toDouble(),
            (point["lng"] as num).toDouble(),
          );
        }).toList();
      }).toList();
    }
    return null;
  } catch (e) {
    if (!context.mounted) return null;
  debugPrint("Boundary error: $e");

  if (!context.mounted) return null;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Error: $e"),
    ),
  );
    return null;
  }
}