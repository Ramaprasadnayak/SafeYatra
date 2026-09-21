import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

Future<Map<String, dynamic>?> getDistrictBoundaries(String distname, BuildContext context) async {
  try {
    if (distname.trim().isEmpty) {
      return null;
    }

    String? apiUrl = dotenv.env["apiUrl"];
    if (apiUrl == null || apiUrl.isEmpty) {
      if (!context.mounted) return null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Configuration error"),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }

    final response = await http.get(
      Uri.parse(
        "http://$apiUrl/api/districts/$distname/coordinates",
      ),
      headers: {
        "Content-Type": "application/json",
      },
    ).timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        throw Exception("Request timeout");
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["message"] == "retrieved boundary successfully") {
        final String matchedDistrict = data["matched_name"];
        final List<dynamic> polygons = data["polygons"];
        final boundaries = polygons.map<List<LatLng>>((polygon) {
          return (polygon as List).map<LatLng>((point) {
            return LatLng(
              (point["lat"] as num).toDouble(),
              (point["lng"] as num).toDouble(),
            );
          }).toList();
        }).toList();
        return {
          "boundaries": boundaries,
          "matchedDistrict": matchedDistrict,
          "center": data["center"]
        };
      }
    }

    if (!context.mounted) return null;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("District boundary not found"),
        backgroundColor: Colors.red,
      ),
    );
    return null;
  } on FormatException {
    if (!context.mounted) return null;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Invalid server response"),
        backgroundColor: Colors.red,
      ),
    );
    return null;
  } catch (e) {
    if (!context.mounted) return null;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error loading boundary: ${e.toString()}"),
        backgroundColor: Colors.red,
      ),
    );
    return null;
  }
}