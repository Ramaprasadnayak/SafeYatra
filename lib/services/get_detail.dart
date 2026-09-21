import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const Duration _requestTimeout = Duration(seconds: 10);
Future<List<String?>> getLocation() async {
  final prefs = await SharedPreferences.getInstance();

  String? read(String key) {
    final value = prefs.getString(key);
    return (value == null || value.isEmpty) ? null : value;
  }

  return [read("city"), read("district"), read("state"), read("nation")];
}
Future<http.Response> _authorizedGet(
  User user,
  Uri uri, {
  bool forceRefresh = false,
}) async {
  final token = await user.getIdToken(forceRefresh);
  if (token == null || token.isEmpty) {
    throw StateError("Missing Firebase ID token");
  }

  return http
      .get(uri, headers: {"Authorization": "Bearer $token"})
      .timeout(_requestTimeout);
}

Future<Map<String, dynamic>?> getUserInfo(BuildContext context) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }

    final apiUrl = dotenv.env["apiUrl"];
    if (apiUrl == null || apiUrl.isEmpty) {
      return null;
    }

    final uri = Uri.parse("https://$apiUrl/auth/getinfo");

    var response = await _authorizedGet(user, uri);

    // Cached token rejected (expired/revoked) -> retry once with a fresh one.
    if (response.statusCode == 401) {
      response = await _authorizedGet(user, uri, forceRefresh: true);
    }

    if (response.statusCode != 200) {
      return null;
    }

    final data = jsonDecode(response.body);
    if (data is Map &&
        data["message"] == "retrieved info" &&
        data["info"] is Map) {
      return Map<String, dynamic>.from(data["info"] as Map);
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
