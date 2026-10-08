import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class EmailService {
  static const Duration _timeout = Duration(seconds: 30);
  static String _baseUrl() {
    final raw = dotenv.env['apiUrl']?.trim() ?? '';
    if (raw.isEmpty) {
      throw Exception('API URL is not configured');
    }
    final url = raw.startsWith('http://') || raw.startsWith('https://')
        ? raw
        : 'https://$raw';
    return url.replaceFirst(RegExp(r'/+$'), '');
  }

  static Future<int> sendSosAlert({
    required String locality,
    required String district,
    required String coordinates,
    double? latitude,
    double? longitude,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('You are not signed in');
    }

    String? token;
    try {
      token = await user.getIdToken(
        true,
      ); 
    } catch (_) {}
    if (token == null || token.isEmpty) {
      throw Exception('Unable to authenticate. Please log in again.');
    }

    final uri = Uri.parse('${_baseUrl()}/sos/trigger');

    final http.Response res;
    try {
      res = await http
          .post(
            uri,
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
          .timeout(_timeout);
    } on TimeoutException {
      throw Exception('Server took too long to respond');
    } catch (_) {
      throw Exception('Network error. Please try again.');
    }

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
    if (res.statusCode == 200) {
      final sentTo = data['sent_to'];
      if (sentTo is List) return sentTo.length;
      if (sentTo is int) return sentTo;
      return 0;
    }
    final detail = data['detail'];
    if (detail != null && detail.toString().trim().isNotEmpty) {
      throw Exception(detail.toString());
    }

    throw Exception('Failed to send SOS email (${res.statusCode})');
  }
}
