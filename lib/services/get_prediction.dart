import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
Future<String?> predict(BuildContext context,String districtname) async {
  try {
    String apiUrl = dotenv.env["apiUrl"]!;
    final response = await http.get(
      Uri.parse("http://$apiUrl/ml/predict/$districtname"),
      headers: {
        "Content-Type": "application/json",
      },
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data["message"] == "Prediction Successful") {
      return data["translated_text"];
    }

    if (!context.mounted) return null;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          data["detail"] ?? data["message"] ?? "Translation Failed",
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );

    return null;
  } catch (e) {
    if (!context.mounted) return null;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error: $e"),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );

    return null;
  }
}