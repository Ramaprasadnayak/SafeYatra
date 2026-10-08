import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SosEmailException implements Exception {
  final String message;
  const SosEmailException(this.message);

  @override
  String toString() => message;
}

class EmailService {
  static const Duration _timeout = Duration(seconds: 30);

  static String _baseUrl() {
    final raw = dotenv.env['apiUrl']?.trim() ?? '';
    if (raw.isEmpty) {
      throw const SosEmailException('API URL is not configured');
    }
    final url =
        raw.startsWith('http://') || raw.startsWith('https://') ? raw : 'https://$raw';
    return url.replaceFirst(RegExp(r'/+$'), '');
  }

  static Uri _uri(String path) => Uri.parse('${_baseUrl()}$path');

  static Future<Map<String, String>> _headers({bool json = false}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw const SosEmailException('Please log in again');
    }
    String? token;
    try {
      token = await user.getIdToken(true); // force refresh, avoids expired tokens
    } catch (_) {}
    if (token == null || token.isEmpty) {
      throw const SosEmailException('Unable to authenticate. Please log in again.');
    }
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      if (json) 'Content-Type': 'application/json',
    };
  }

  static String _error(http.Response r, String fallback) {
    try {
      final data = jsonDecode(r.body);
      if (data is Map && data['detail'] != null) {
        return data['detail'].toString();
      }
    } catch (_) {}
    return '$fallback (${r.statusCode})';
  }

  static Future<http.Response> _run(Future<http.Response> Function() call) async {
    try {
      return await call().timeout(_timeout);
    } on TimeoutException {
      throw const SosEmailException('Server took too long to respond');
    } on SosEmailException {
      rethrow;
    } catch (_) {
      throw const SosEmailException('Network error. Please try again.');
    }
  }

  static Future<List<String>> getEmails() async {
    final headers = await _headers();
    final r = await _run(() => http.get(_uri('/sos/emails'), headers: headers));
    if (r.statusCode != 200) {
      throw SosEmailException(_error(r, 'Failed to load SOS emails'));
    }
    try {
      final data = jsonDecode(r.body);
      return (data['emails'] as List)
          .map((e) => e.toString().trim().toLowerCase())
          .where((e) => e.isNotEmpty)
          .toSet()
          .take(2)
          .toList();
    } catch (_) {
      throw const SosEmailException('Invalid response from server');
    }
  }

  static Future<void> addEmail(String email) async {
    final clean = email.trim().toLowerCase();
    if (clean.isEmpty) {
      throw const SosEmailException('Email address cannot be empty');
    }
    final headers = await _headers(json: true);
    final r = await _run(() => http.post(
          _uri('/sos/add-email'),
          headers: headers,
          body: jsonEncode({'email': clean}),
        ));
    if (r.statusCode != 200) {
      throw SosEmailException(_error(r, 'Failed to add SOS email'));
    }
  }

  static Future<void> deleteEmail(String email) async {
    final clean = email.trim().toLowerCase();
    if (clean.isEmpty) {
      throw const SosEmailException('Email address cannot be empty');
    }
    final headers = await _headers(json: true);
    final r = await _run(() => http.delete(
          _uri('/sos/delete-email'),
          headers: headers,
          body: jsonEncode({'email': clean}),
        ));
    if (r.statusCode != 200) {
      throw SosEmailException(_error(r, 'Failed to delete SOS email'));
    }
  }

  static Future<int> sendSosAlert({
    required String locality,
    required String district,
    required String coordinates,
    double? latitude,
    double? longitude,
  }) async {
    final headers = await _headers(json: true);
    final r = await _run(() => http.post(
          _uri('/sos/trigger'),
          headers: headers,
          body: jsonEncode({
            'locality': locality,
            'district': district,
            'coordinates': coordinates,
            'latitude': latitude,
            'longitude': longitude,
          }),
        ));

    if (r.statusCode != 200) {
      throw SosEmailException(_error(r, 'Failed to send SOS alert'));
    }
    try {
      final data = jsonDecode(r.body) as Map<String, dynamic>;
      return (data['sent_to'] as List).length;
    } catch (_) {
      throw const SosEmailException('Invalid response from server');
    }
  }
}