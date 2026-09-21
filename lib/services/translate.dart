import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String?> translate(BuildContext context, String source, String target, String mytext) async {
  try {
    if (mytext.trim().isEmpty) {
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

    final response = await http.post(
      Uri.parse("https://$apiUrl/translate/"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "source": source,
        "target": target,
        "text": mytext,
      }),
    ).timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        throw Exception("Translation request timeout");
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["message"] == "Translation Successful") {
        return data["translated_text"];
      }
    }

    if (!context.mounted) return null;

    final data = jsonDecode(response.body);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          data["detail"] ?? data["message"] ?? "Translation failed",
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
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
        content: Text("Translation error: ${e.toString()}"),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
    return null;
  }
}