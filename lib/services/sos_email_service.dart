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

  static const Duration _timeout =
      Duration(seconds: 30);

  String _getApiUrl() {

    final apiUrl = dotenv.env['apiUrl'];

    if (apiUrl == null ||
        apiUrl.trim().isEmpty) {

      throw const SosEmailException(
        'API URL is not configured',
      );
    }

    String url = apiUrl.trim();

    if (!url.startsWith('http://') &&
        !url.startsWith('https://')) {

      url = 'https://$url';
    }

    return url.replaceFirst(
      RegExp(r'/$'),
      '',
    );
  }

  Future<String> _getToken() async {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {

      throw const SosEmailException(
        'Please log in again',
      );
    }

    try {

      final token =
          await user.getIdToken();

      if (token == null ||
          token.isEmpty) {

        throw const SosEmailException(
          'Authentication failed. Please log in again.',
        );
      }

      return token;

    } catch (e) {

      if (e is SosEmailException) {
        rethrow;
      }

      throw const SosEmailException(
        'Unable to authenticate. Please log in again.',
      );
    }
  }


  Future<Map<String, String>> _headers({
    bool includeContentType = false,
  }) async {

    final token =
        await _getToken();

    return {
      'Accept': 'application/json',

      'Authorization':
          'Bearer $token',

      if (includeContentType)
        'Content-Type':
            'application/json',
    };
  }

  Uri _endpoint(String path) {

    return Uri.parse(
      '${_getApiUrl()}$path',
    );
  }

  String _errorMessage(
    http.Response response,
    String fallback,
  ) {

    try {

      final data =
          jsonDecode(response.body);

      if (data is Map &&
          data['detail'] != null) {

        return data['detail'].toString();
      }

    } catch (_) {
      // Ignore JSON parsing error.
    }

    if (response.body
        .trim()
        .isNotEmpty) {

      return response.body.trim();
    }

    return fallback;
  }

  Future<List<String>> getEmails() async {

    try {

      final response = await http
          .get(
            _endpoint('/sos/emails'),
            headers: await _headers(),
          )
          .timeout(_timeout);

      if (response.statusCode != 200) {

        throw SosEmailException(
          _errorMessage(
            response,
            'Failed to load SOS emails',
          ),
        );
      }

      final data =
          jsonDecode(response.body);

      if (data is! Map ||
          data['emails'] is! List) {

        throw const SosEmailException(
          'Invalid response from server',
        );
      }

      final emails =
          (data['emails'] as List)
              .map(
                (item) => item
                    .toString()
                    .trim()
                    .toLowerCase(),
              )
              .where(
                (email) =>
                    email.isNotEmpty,
              )
              .toSet()
              .take(2)
              .toList();

      return emails;

    } on TimeoutException {

      throw const SosEmailException(
        'Server took too long to respond',
      );

    } on SosEmailException {

      rethrow;

    } on FormatException {

      throw const SosEmailException(
        'Invalid response from server',
      );

    } catch (_) {

      throw const SosEmailException(
        'Unable to load SOS emails',
      );
    }
  }

  Future<void> addEmail(
    String email,
  ) async {

    final cleanEmail =
        email.trim().toLowerCase();

    if (cleanEmail.isEmpty) {

      throw const SosEmailException(
        'Email address cannot be empty',
      );
    }

    try {

      final response = await http
          .post(
            _endpoint('/sos/add-email'),

            headers: await _headers(
              includeContentType: true,
            ),

            body: jsonEncode({
              'email': cleanEmail,
            }),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return;
      }

      throw SosEmailException(
        _errorMessage(
          response,
          'Failed to add SOS email',
        ),
      );

    } on TimeoutException {

      throw const SosEmailException(
        'Server took too long to respond',
      );

    } on SosEmailException {

      rethrow;

    } catch (_) {

      throw const SosEmailException(
        'Network error. Please try again.',
      );
    }
  }
  Future<void> deleteEmail(
    String email,
  ) async {

    final cleanEmail =
        email.trim().toLowerCase();

    if (cleanEmail.isEmpty) {

      throw const SosEmailException(
        'Email address cannot be empty',
      );
    }
    try {
      final response = await http
          .delete(
            _endpoint('/sos/delete-email'),
            headers: await _headers(
              includeContentType: true,
            ),
            body: jsonEncode({
              'email': cleanEmail,
            }),
          )
          .timeout(_timeout);
      if (response.statusCode == 200) {
        return;
      }
      throw SosEmailException(
        _errorMessage(
          response,
          'Failed to delete SOS email',
        ),
      );
    } on TimeoutException {
      throw const SosEmailException(
        'Server took too long to respond',
      );

    } on SosEmailException {

      rethrow;

    } catch (_) {

      throw const SosEmailException(
        'Network error. Please try again.',
      );
    }
  }

  Future<Map<String, dynamic>> triggerSos({
    required String locality,
    required String district,
    required String coordinates,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final response = await http
          .post(
            _endpoint('/sos/trigger'),
            headers: await _headers(
              includeContentType: true,
            ),
            body: jsonEncode({
              'latitude': latitude,
              'longitude': longitude,
              'locality': locality,
              'district': district,
              'coordinates': coordinates,
            }),
          )
          .timeout(_timeout);
      if (response.statusCode == 200) {
        final data =jsonDecode(response.body);
        if (data is Map<String, dynamic>) {
          return data;
        }
        throw const SosEmailException(
          'Invalid response from server',
        );
      }
      throw SosEmailException(
        _errorMessage(
          response,
          'Failed to send SOS alert',
        ),
      );
    } on TimeoutException {
      throw const SosEmailException(
        'Server took too long to respond',
      );
    } on SosEmailException {
      rethrow;

    } catch (_) {

      throw const SosEmailException(
        'Unable to send SOS alert. Please try again.',
      );
    }
  }
}