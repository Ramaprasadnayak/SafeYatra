import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safeyatra/features/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';


Future<void> register(String username,String email,String password,BuildContext context) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    final user=userCredential.user;
    if (user == null) {
      if(!context.mounted) return;
      ScaffoldMessenger.of(context,).showSnackBar(const SnackBar(content: Text("couldnt register")));
      return;
    }
    String apiUrl = dotenv.env["apiUrl"]!;
    final response = await http.post(
      Uri.parse("http://$apiUrl/auth/register"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "firebaseid": user.uid,
        "username": username,
        "email":user.email,
      }),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data["message"] == "User registered") {
      if(!context.mounted) return;
      ScaffoldMessenger.of(context,).showSnackBar(const SnackBar(content: Text("register sucessful.")));
     
    }
    if(!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );

  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Invalid credential.")));
  }
}

Future<bool> verifyuser(String username,BuildContext context) async {
  try {
    String apiUrl = dotenv.env["apiUrl"]!;

    final response = await http.post(
      Uri.parse("http://$apiUrl/auth/verifyuser"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "username": username
      }),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data["message"] == "Unique user") {
      return true;
    }
    else {
      return false;
    }
  } on Exception catch (e) {
    if(!context.mounted) return false;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Something went wrong")));
    return false;
  }
}


Future<void> login(String email, String password, BuildContext context) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    
    if(!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("login sucessfull")));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Invalid credential.")));
  }
}
