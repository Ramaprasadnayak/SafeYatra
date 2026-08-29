import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<String?>> getLocation() async {
  final prefs = await SharedPreferences.getInstance();
  final city=prefs.getString("city");
  final district=prefs.getString("district");
  final state=prefs.getString("state");
  final nation=prefs.getString("nation");
  return [city,district,state,nation];
}


Future<Map<String, dynamic>?> getUserInfo(BuildContext context) async {
  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return null;
    }

    final token = await user.getIdToken();

    final apiUrl = dotenv.env["apiUrl"];

    if (apiUrl == null || apiUrl.isEmpty) {
      return null;
    }

    final response = await http.get(
      Uri.parse("http://$apiUrl/auth/getinfo"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["message"] == "retrieved info") {
        return Map<String, dynamic>.from(data["info"]);
      }
    }

    return null;
  } catch (e) {
    if (!context.mounted) return null;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Unable to retrieve user information."),
      ),
    );

    return null;
  }
}