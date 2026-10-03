import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safeyatra/pages/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

Future<void> register(String username,String email,String phno,String password,BuildContext context) async {
  try {
    final apiUrl = dotenv.env["apiUrl"];

    if (apiUrl == null || apiUrl.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Configuration error. Please contact support."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final usrRes = await http.get(Uri.parse(
        "https://$apiUrl/auth/verifyusr/${Uri.encodeComponent(username)}",
      ),
      headers: {"Content-Type": "application/json"},
    );

    if (usrRes.statusCode != 200) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Unable to verify username. Server error: ${usrRes.statusCode}",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final usrData = jsonDecode(usrRes.body);
    if (usrData["exists"] == true) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username already exists"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    final user = userCredential.user;
    if (user == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registration failed. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final response = await http.post(
          Uri.parse("https://$apiUrl/auth/register"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "firebaseid": user.uid,
            "username": username,
            "phno": phno,
            "email": user.email,
          }),
        ).timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            throw Exception("Request timeout. Please check your connection.");
          },
        );
    if (!context.mounted) return;
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data["message"] == "User registered") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registration successful!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(data["message"] ?? "Registration failed"),
        backgroundColor: Colors.red,
      ),
    );
  } on FirebaseAuthException catch (e) {
    if (!context.mounted) return;
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
    );
  } on Exception catch (e) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error: ${e.toString()}"),
        backgroundColor: Colors.red,
      ),
    );
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

    final response = await http
        .post(
          Uri.parse("https://$apiUrl/auth/verifyuser"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"username": username}),
        )
        .timeout(
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

Future<void> login(String email, String password, BuildContext context) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

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
