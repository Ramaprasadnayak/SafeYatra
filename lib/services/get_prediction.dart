import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<Map<String, dynamic>?> predict(BuildContext context, String districtname) async {
  try {
    if (districtname.trim().isEmpty) {
      return null;
    }

    String? apiUrl = dotenv.env["apiUrl"];
    if (apiUrl == null || apiUrl.isEmpty) {
      if (!context.mounted) return null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Configuration error"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return null;
    }

    final response = await http.get(
      Uri.parse("http://$apiUrl/ml/predict/$districtname"),
      headers: {
        "Content-Type": "application/json",
      },
    ).timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        throw Exception("Prediction request timeout");
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["message"] == "Prediction Successful") {
        return data["result"];
      }
    }

    if (!context.mounted) return null;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Failed to get safety prediction"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
    return null;
  } on FormatException {
    if (!context.mounted) return null;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Invalid server response"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
    return null;
  } catch (e) {
    if (!context.mounted) return null;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Prediction error: ${e.toString()}"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
    return null;
  }
}