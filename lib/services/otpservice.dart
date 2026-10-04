import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void _showError(BuildContext context, String message) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 2),
    ),
  );
}
Future<bool> sendOtp(BuildContext context, String phoneNumber) async {
  try {
    if (phoneNumber.trim().isEmpty) return false;

    String? apiUrl = dotenv.env["apiUrl"];
    if (apiUrl == null || apiUrl.isEmpty) {
      _showError(context, "Configuration error");
      return false;
    }

    final response = await http.post(
      Uri.parse("https://$apiUrl/otp/send/"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "phone": phoneNumber,
      }),
    ).timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        throw Exception("OTP request timeout");
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["message"] == "OTP sent") {
        return true;
      }
    }

    final data = jsonDecode(response.body);
    _showError(context, data["detail"] ?? data["message"] ?? "Failed to send OTP");
    return false;
  } on FormatException {
    _showError(context, "Invalid server response");
    return false;
  } catch (e) {
    _showError(context, "OTP error: ${e.toString()}");
    return false;
  }
}

/// Checks the [code] the user typed. Returns true if it is correct.
Future<bool> verifyOtp(BuildContext context, String phoneNumber, String code) async {
  try {
    if (code.trim().isEmpty) return false;

    String? apiUrl = dotenv.env["apiUrl"];
    if (apiUrl == null || apiUrl.isEmpty) {
      _showError(context, "Configuration error");
      return false;
    }

    final response = await http.post(
      Uri.parse("https://$apiUrl/otp/verify/"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "phone": phoneNumber,
        "code": code.trim(),
      }),
    ).timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        throw Exception("Verification request timeout");
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["message"] == "OTP verified") {
        return true;
      }
    }

    final data = jsonDecode(response.body);
    _showError(context, data["detail"] ?? data["message"] ?? "Verification failed");
    return false;
  } on FormatException {
    _showError(context, "Invalid server response");
    return false;
  } catch (e) {
    _showError(context, "Verification error: ${e.toString()}");
    return false;
  }
}