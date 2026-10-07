import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EmailService {
  static String? apiUrl = dotenv.env["apiUrl"];

  static Future<int> sendSosAlert({
    required String locality,
    required String district,
    required String coordinates,
    double? latitude,
    double? longitude,
  }) async {
    final token =
        await FirebaseAuth.instance.currentUser?.getIdToken();

    if (token == null) {
      throw Exception('You are not signed in');
    }

    if (apiUrl == null || apiUrl!.trim().isEmpty) {
      throw Exception('API URL is not configured');
    }

    final res = await http
        .post(
          Uri.parse(
            'https://${apiUrl!.trim()}/sos/send-alert',
          ),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'latitude': latitude,
            'longitude': longitude,
            'locality': locality,
            'district': district,
            'coordinates': coordinates,
          }),
        )
        .timeout(
          const Duration(seconds: 30),
        );

    // Try to decode JSON safely
    Map<String, dynamic> data = {};

    try {
      final decoded = jsonDecode(res.body);

      if (decoded is Map<String, dynamic>) {
        data = decoded;
      }
    } catch (_) {
      throw Exception(
        'Server returned an invalid response (${res.statusCode})',
      );
    }

    // SUCCESS
    if (res.statusCode == 200) {
      return (data['sent_to'] as int?) ?? 0;
    }

    final detail = data['detail'];

    if (detail != null &&
        detail.toString().trim().isNotEmpty) {
      throw Exception(detail.toString());
    }

    throw Exception(
      'Failed to send SOS email (${res.statusCode})',
    );
  }
}