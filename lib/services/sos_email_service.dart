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

class SosEmailService {
  static const Duration _timeout = Duration(seconds: 30);

  Future<String> _getApiUrl() async {
    final apiUrl = dotenv.env['apiUrl'];

    if (apiUrl == null || apiUrl.trim().isEmpty) {
      throw const SosEmailException('API URL is not configured');
    }

    return apiUrl.trim().replaceFirst(RegExp(r'/$'), '');
  }

  Future<String> _getToken() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw const SosEmailException('Please log in again');
    }

    final token = await user.getIdToken();

    if (token == null || token.isEmpty) {
      throw const SosEmailException(
        'Authentication failed. Please log in again.',
      );
    }

    return token;
  }

  Future<Map<String, String>> _headers({
    bool includeContentType = false,
  }) async {
    final token = await _getToken();

    return {
      if (includeContentType) 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<String> _endpoint(String path) async {
    final apiUrl = await _getApiUrl();
    return 'https://$apiUrl$path';
  }

  String _errorMessage(http.Response response, String fallback) {
    try {
      final data = jsonDecode(response.body);

      if (data is Map && data['detail'] != null) {
        return data['detail'].toString();
      }
    } catch (_) {
      if (response.body.isNotEmpty) {
        return response.body;
      }
    }

    return fallback;
  }

  Future<List<String>> getEmails() async {
    try {
      final response = await http
          .get(
            Uri.parse(await _endpoint('/sos/emails')),
            headers: await _headers(),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List<String> emails = [];

        if (data is List) {
          emails = data
              .map((item) => item.toString().trim().toLowerCase())
              .where((email) => email.isNotEmpty)
              .toList();
        } else if (data is Map && data['emails'] is List) {
          emails = (data['emails'] as List)
              .map((item) => item.toString().trim().toLowerCase())
              .where((email) => email.isNotEmpty)
              .toList();
        }

        return emails.take(2).toSet().toList();
      }

      throw SosEmailException(
        'Error ${response.statusCode}: '
        '${_errorMessage(response, 'Failed to load SOS emails')}',
      );
    } on TimeoutException {
      throw const SosEmailException('Server took too long to respond');
    } on SosEmailException {
      rethrow;
    } catch (_) {
      throw const SosEmailException('Unable to load SOS emails');
    }
  }

  Future<void> addEmail(String email) async {
    try {
      final response = await http
          .post(
            Uri.parse(await _endpoint('/sos/add-email')),
            headers: await _headers(includeContentType: true),
            body: jsonEncode({'email': email}),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return;
      }

      throw SosEmailException(
        'Error ${response.statusCode}: '
        '${_errorMessage(response, 'Failed to add email')}',
      );
    } on TimeoutException {
      throw const SosEmailException('Server took too long to respond');
    } on SosEmailException {
      rethrow;
    } catch (_) {
      throw const SosEmailException('Network error. Please try again.');
    }
  }

  Future<void> deleteEmail(String email) async {
    try {
      final response = await http
          .delete(
            Uri.parse(await _endpoint('/sos/delete-email')),
            headers: await _headers(includeContentType: true),
            body: jsonEncode({'email': email}),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return;
      }

      throw SosEmailException(
        'Error ${response.statusCode}: '
        '${_errorMessage(response, 'Failed to delete email')}',
      );
    } on TimeoutException {
      throw const SosEmailException('Server took too long to respond');
    } on SosEmailException {
      rethrow;
    } catch (_) {
      throw const SosEmailException('Network error. Please try again.');
    }
  }
}
