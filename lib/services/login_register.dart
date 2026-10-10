import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safeyatra/pages/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> startapp(BuildContext context) async {
  try {
    final apiUrl = dotenv.env["apiUrl"];

    if (apiUrl == null || apiUrl.isEmpty) {
      if (context.mounted) {
        _showError(
          context,
          "Configuration error. Please contact support.",
        );
      }
      return false;
    }

    final baseUrl = apiUrl.startsWith("http")
        ? apiUrl
        : "https://$apiUrl";

    final response = await http
        .get(
          Uri.parse("$baseUrl/"),
          headers: {
            "Content-Type": "application/json",
          },
        )
        .timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["message"] == "SafeYatra API is running") {
        debugPrint("SafeYatra backend is ready!");
        return true;
      }
    }

    debugPrint("Backend response: ${response.statusCode}");
    return false;
  } catch (e) {
    debugPrint("Backend startup check failed: $e");
    return false;
  }
}
Future<void> login(String email, String password, BuildContext context) async {
  try {
    final userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    final user = userCredential.user;
    if (user == null) {
      _showError(context, "Login failed. Please try again.");
      return;
    }
    
    final String? token = await user.getIdToken();
    debugPrint("🔥 Firebase ID Token: $token");

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

Future<bool> register(
  String username,
  String email,
  String password,
  BuildContext context,
) async {
  try {
    final apiUrl = dotenv.env["apiUrl"];

    if (apiUrl == null || apiUrl.isEmpty) {
      _showError(
        context,
        "Configuration error. Please contact support.",
      );
      return false;
    }
    final usrRes = await http
        .get(
          Uri.parse(
            "https://$apiUrl/auth/verifyusr/"
            "${Uri.encodeComponent(username)}",
          ),
          headers: {"Content-Type": "application/json"},
        )
        .timeout(const Duration(seconds: 15));

    if (usrRes.statusCode != 200) {
      _showError(context, "Unable to verify username.");
      return false;
    }

    final usrData = jsonDecode(usrRes.body);

    if (usrData["exists"] == true) {
      _showError(context, "Username already exists");
      return false;
    }

    // 2. Create Firebase account
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      _showError(context, "Registration failed. Please try again.");
      return false;
    }

    // 3. Save username in Firebase profile
    await user.updateDisplayName(username);

    // 4. Send verification email
    await user.sendEmailVerification();

    // Do NOT register in MongoDB here.
    // MongoDB registration happens only after verification.
    return true;
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
  } catch (e) {
    _showError(context, "Registration failed: $e");
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
Future<bool> completeRegistration() async {
  try {
    final apiUrl = dotenv.env["apiUrl"];
    final user = FirebaseAuth.instance.currentUser;

    if (apiUrl == null || apiUrl.isEmpty || user == null) {
      return false;
    }

    await user.reload();

    final verifiedUser = FirebaseAuth.instance.currentUser;

    if (verifiedUser == null || !verifiedUser.emailVerified) {
      return false;
    }

    final idToken = await verifiedUser.getIdToken(true);

    final response = await http
        .post(
          Uri.parse(
            "${apiUrl.startsWith("http") ? apiUrl : "https://$apiUrl"}/auth/register",
          ),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $idToken",
          },
          body: jsonEncode({
            "firebaseid": verifiedUser.uid,
            "username": verifiedUser.displayName,
            "email": verifiedUser.email,
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      debugPrint("Registration failed: ${response.body}");
      return false;
    }

    final data = jsonDecode(response.body);
    if (data["message"] == "User registered") {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("uid", verifiedUser.uid);
      return true;
    }

    return false;
  } catch (e) {
    debugPrint("Complete registration error: $e");
    return false;
  }
}