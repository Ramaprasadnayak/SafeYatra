import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

const String kDefaultProfilePic = 'https://res.cloudinary.com/ubt9l5i7/image/upload/v1791478335/profile_toqodm.png';

class ProfilePicException implements Exception {
  final String message;
  const ProfilePicException(this.message);
  @override
  String toString() => message;
}
class ProfilePicService {
  static const Duration _timeout = Duration(seconds: 30);
  static const Duration _uploadTimeout = Duration(seconds: 60);
  static String _baseUrl() {
    final raw = dotenv.env['apiUrl']?.trim() ?? '';
    if (raw.isEmpty) {
      throw const ProfilePicException('API URL is not configured');
    }
    final url = raw.startsWith('http://') || raw.startsWith('https://')
        ? raw
        : 'https://$raw';
    return url.replaceFirst(RegExp(r'/+$'), '');
  }
  static Uri _uri(String path) => Uri.parse('${_baseUrl()}$path');
  static Future<Map<String, String>> _headers({bool json = false}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw const ProfilePicException('Please log in again');
    }
    String? token;
    try {
      token = await user.getIdToken(true); 
    } catch (_) {}
    if (token == null || token.isEmpty) {
      throw const ProfilePicException(
          'Unable to authenticate. Please log in again.');
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
  static Future<http.Response> _run(
      Future<http.Response> Function() call) async {
    try {
      return await call().timeout(_timeout);
    } on TimeoutException {
      throw const ProfilePicException('Server took too long to respond');
    } on ProfilePicException {
      rethrow;
    } catch (_) {
      throw const ProfilePicException('Network error. Please try again.');
    }
  }
  static Future<String> getSavedUrl() async {
    try {
      final headers = await _headers();
      final r = await _run(() => http.get(_uri('/profile/pic'), headers: headers));
      if (r.statusCode == 200) {
        final url = (jsonDecode(r.body)['url'] as String?)?.trim();
        if (url != null && url.isNotEmpty) return url;
      }
    } catch (_) {}
    return kDefaultProfilePic;
  }
  static Future<void> saveUrl(String url) async {
    final clean = url.trim();
    if (clean.isEmpty) {
      throw const ProfilePicException('Image URL cannot be empty');
    }
    final headers = await _headers(json: true);
    final r = await _run(() => http.put(
          _uri('/profile/pic'),
          headers: headers,
          body: jsonEncode({'url': clean}),
        ));
    if (r.statusCode != 200) {
      throw ProfilePicException(_error(r, 'Failed to save profile picture'));
    }
  }
  static Future<void> resetToDefault() async {
    final headers = await _headers();
    final r = await _run(() => http.delete(_uri('/profile/pic'), headers: headers));
    if (r.statusCode != 200) {
      throw ProfilePicException(_error(r, 'Failed to reset profile picture'));
    }
  }
  static Future<String> upload(File file) async {
    final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'];
    final preset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'];

    if (cloudName == null || preset == null) {
      throw const ProfilePicException('Cloudinary keys missing in .env');
    }

    final uri =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    try {
      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = preset
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final streamed = await request.send().timeout(_uploadTimeout);
      final body = await streamed.stream.bytesToString();

      if (streamed.statusCode != 200) {
        String msg = 'Upload failed';
        try {
          msg = (jsonDecode(body)['error']?['message'] as String?) ?? msg;
        } catch (_) {}
        throw ProfilePicException(msg);
      }

      return jsonDecode(body)['secure_url'] as String;
    } on TimeoutException {
      throw const ProfilePicException('Upload took too long. Please try again.');
    } on ProfilePicException {
      rethrow;
    } catch (_) {
      throw const ProfilePicException('Network error. Please try again.');
    }
  }
}