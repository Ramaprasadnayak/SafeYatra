import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safeyatra/pages/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> login(String email, String password, BuildContext context) async {
  try {
    final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    final user = userCredential.user;
    if (user == null) {
      _showError(context, "Login failed. Please try again.");
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("uid", user.uid);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Login successful!"),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  } on FirebaseAuthException catch (e) {
    if (!context.mounted) return;
    String errorMessage;
    switch (e.code) {
      case 'user-not-found':
        errorMessage = "No account found with this email.";
        break;
      case 'wrong-password':
        errorMessage = "Incorrect password.";
        break;
      case 'invalid-email':
        errorMessage = "Invalid email format.";
        break;
      case 'user-disabled':
        errorMessage = "This account has been disabled.";
        break;
      case 'invalid-credential':
        errorMessage = "Invalid email or password.";
        break;
      default:
        errorMessage = "Authentication error: ${e.message}";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
    );
  } on Exception catch (e) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Login failed: ${e.toString()}"),
        backgroundColor: Colors.red,
      ),
    );
  }
}

void _showError(BuildContext context, String message) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
}

Future<bool> register(String username,String email,String password,BuildContext context) async {
  try {
    final apiUrl = dotenv.env["apiUrl"];
    if (apiUrl == null || apiUrl.isEmpty) {
      _showError(context, "Configuration error. Please contact support.");
      return false;
    }
    final usrRes = await http.get(
          Uri.parse(
            "https://$apiUrl/auth/verifyusr/${Uri.encodeComponent(username)}",
          ),
          headers: {"Content-Type": "application/json"},
        ).timeout(
          const Duration(seconds: 15),
          onTimeout: () =>
              throw Exception("Request timeout. Please check your connection."),
        );
    if (usrRes.statusCode != 200) {
      _showError(
        context,
        "Unable to verify username. Server error: ${usrRes.statusCode}",
      );
      return false;
    }
    final usrData = jsonDecode(usrRes.body);
    if (usrData["exists"] == true) {
      _showError(context, "Username already exists");
      return false;
    }
    final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    final user = userCredential.user;
    if (user == null) {
      _showError(context, "Registration failed. Please try again.");
      return false;
    }
    await user.updateDisplayName(username);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("uid", user.uid);
    final response = await http
        .post(
          Uri.parse("https://$apiUrl/auth/register"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "firebaseid": user.uid,
            "username": username,
            "email": user.email,
          }),
        ).timeout(
          const Duration(seconds: 15),
          onTimeout: () =>
              throw Exception("Request timeout. Please check your connection."),
        );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data["message"] == "User registered") {
      return true;
    }
    _showError(context, data["message"] ?? "Registration failed");
    return false;
  } on FirebaseAuthException catch (e) {
    String errorMessage;
    switch (e.code) {
      case 'email-already-in-use':
        errorMessage = "This email is already registered.";
        break;
      case 'weak-password':
        errorMessage = "Password is too weak.";
        break;
      case 'invalid-email':
        errorMessage = "Invalid email format.";
        break;
      case 'network-request-failed':
        errorMessage = "Network error. Check your internet connection.";
        break;
      default:
        errorMessage = e.message ?? "Authentication error occurred.";
    }
    _showError(context, errorMessage);
    return false;
  } on Exception catch (e) {
    _showError(context, "Error: ${e.toString()}");
    return false;
  }
}
Future<bool> verifyuser(String username, BuildContext context) async {
  try {
    String? apiUrl = dotenv.env["apiUrl"];
    if (apiUrl == null || apiUrl.isEmpty) {
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Configuration error. Please contact support."),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    final response = await http.post(
          Uri.parse("https://$apiUrl/auth/verifyuser"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"username": username}),
        ).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw Exception("Request timeout");
          },
        );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["message"] == "Unique user";
    }
    return false;
  } on Exception catch (e) {
    if (!context.mounted) return false;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error verifying username: ${e.toString()}"),
        backgroundColor: Colors.red,
      ),
    );
    return false;
  }
}
