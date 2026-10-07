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
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) throw Exception('You are not signed in');

    final res = await http
        .post(
          Uri.parse('https://$apiUrl/sos/send-alert'),
          headers: {
            'Content-Type': 'application/json',
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
        .timeout(const Duration(seconds: 30));

    final data = jsonDecode(res.body);
    if (res.statusCode == 200) return (data['sent_to'] as int?) ?? 0;
    throw Exception(data['detail'] ?? 'Something went wrong');
  }
}