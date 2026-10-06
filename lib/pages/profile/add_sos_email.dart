import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AddSosEmailPage extends StatefulWidget {
  const AddSosEmailPage({super.key});

  @override
  State<AddSosEmailPage> createState() => _AddSosEmailPageState();
}

class _AddSosEmailPageState extends State<AddSosEmailPage> {
  final List<String> _emails = [];

  bool _loading = false;
  bool _loadingEmails = true;

  static final RegExp _emailRegex =
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void initState() {
    super.initState();
    _loadEmails();
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<String?> _getApiUrl() async {
    final apiUrl = dotenv.env['apiUrl'];

    if (apiUrl == null || apiUrl.trim().isEmpty) {
      _showMessage('API URL is not configured');
      return null;
    }

    return apiUrl.trim().replaceFirst(RegExp(r'/$'), '');
  }

  Future<String?> _getToken() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _showMessage('Please log in again');
      return null;
    }

    final token = await user.getIdToken();

    if (token == null || token.isEmpty) {
      _showMessage('Authentication failed. Please log in again.');
      return null;
    }

    return token;
  }

  Future<void> _loadEmails() async {
    setState(() {
      _loadingEmails = true;
    });

    try {
      final apiUrl = await _getApiUrl();

      if (apiUrl == null) return;

      final token = await _getToken();

      if (token == null) return;

      final endpoint = 'https://$apiUrl/sos/emails';

      final response = await http
          .get(
            Uri.parse(endpoint),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(
            const Duration(seconds: 30),
          );

      if (!mounted) return;

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

        setState(() {
          _emails
            ..clear()
            ..addAll(emails);
        });

        return;
      }

      String errorMessage = 'Failed to load SOS emails';

      try {
        final data = jsonDecode(response.body);

        if (data is Map && data['detail'] != null) {
          errorMessage = data['detail'].toString();
        }
      } catch (_) {}

      _showMessage(
        'Error ${response.statusCode}: $errorMessage',
      );
    } on TimeoutException {
      if (mounted) {
        _showMessage('Server took too long to respond');
      }
    } catch (e) {
      if (mounted) {
        _showMessage('Unable to load SOS emails');
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingEmails = false;
        });
      }
    }
  }

  Future<void> _showAddDialog() async {
    final controller = TextEditingController();

    try {
      final result = await showDialog<String>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Add SOS Email'),
            content: TextField(
              controller: controller,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Email address',
                hintText: 'example@gmail.com',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                final email = value.trim();

                if (email.isNotEmpty) {
                  Navigator.of(dialogContext).pop(email);
                }
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  final email = controller.text.trim();

                  if (email.isEmpty) {
                    return;
                  }

                  Navigator.of(dialogContext).pop(email);
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      );

      if (!mounted || result == null) {
        return;
      }

      final email = result.trim().toLowerCase();

      if (!_emailRegex.hasMatch(email)) {
        _showMessage('Enter a valid email address');
        return;
      }

      if (_emails.contains(email)) {
        _showMessage('Email already added');
        return;
      }

      await _saveEmail(email);
    } finally {
      controller.dispose();
    }
  }

  Future<void> _saveEmail(String email) async {
    if (_loading) return;

    setState(() {
      _loading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        _showMessage('Please log in again');
        return;
      }

      final token = await user.getIdToken();

      if (token == null || token.isEmpty) {
        _showMessage('Authentication failed. Please log in again.');
        return;
      }

      final apiUrl = await _getApiUrl();

      if (apiUrl == null) return;

      final endpoint = 'https://$apiUrl/sos/add-email';

      final response = await http
          .post(
            Uri.parse(endpoint),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'email': email,
            }),
          )
          .timeout(
            const Duration(seconds: 30),
          );

      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() {
          _emails.add(email);
        });

        _showMessage('Email added successfully');
        return;
      }

      String errorMessage = 'Failed to add email';

      try {
        final data = jsonDecode(response.body);

        if (data is Map && data['detail'] != null) {
          errorMessage = data['detail'].toString();
        }
      } catch (_) {
        if (response.body.isNotEmpty) {
          errorMessage = response.body;
        }
      }

      _showMessage(
        'Error ${response.statusCode}: $errorMessage',
      );
    } on TimeoutException {
      if (mounted) {
        _showMessage('Server took too long to respond');
      }
    } catch (e) {
      if (mounted) {
        _showMessage('Network error. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SOS Emails'),
      ),
      body: _loadingEmails
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _emails.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.email_outlined,
                          size: 60,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No SOS email added',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Add an email address to receive SOS alerts.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _emails.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 8);
                  },
                  itemBuilder: (context, index) {
                    final email = _emails[index];

                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.email_outlined),
                        ),
                        title: Text(email),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _loading || _loadingEmails ? null : _showAddDialog,
        icon: _loading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.add),
        label: Text(
          _loading ? 'Adding...' : 'Add Email',
        ),
      ),
    );
  }
}