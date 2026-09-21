import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:safeyatra/pages/auth/phone_page.dart';
import 'package:safeyatra/services/login_register.dart';
import 'package:safeyatra/widgets/buttons.dart';
import 'package:safeyatra/widgets/text_field.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController usrname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void validateInput() async {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      final trimmedUsername = usrname.text.trim();
      final trimmedEmail = email.text.trim();
      final trimmedPassword = password.text.trim();

      if (trimmedUsername.isEmpty || trimmedEmail.isEmpty || trimmedPassword.isEmpty) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("All fields are required"),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (trimmedUsername.length < 3) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Username must be at least 3 characters"),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (!emailRegex.hasMatch(trimmedEmail)) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please enter a valid email address"),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (trimmedPassword.length < 8) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password must be at least 8 characters"),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      register(trimmedUsername, trimmedEmail, trimmedPassword, context);
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Safe ",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              TextSpan(
                text: "Yatra",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1D6FB8),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              Text(
                "Create your Account",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),
              MyTextField( 
                hintText: "Choose a Username",
                height: 56,
                width: 380,
                prefixicon: Icon(Icons.person_outline),
                controller: usrname,
                eyebutton: false,
                hideText: false,
              ),
              const SizedBox(height: 20),
              MyTextField(
                hintText: "Choose a email",
                height: 56,
                width: 380,
                prefixicon: Icon(Icons.email_outlined),
                controller: email,
                eyebutton: false,
                hideText: false,
              ),
              const SizedBox(height: 20),
              MyTextField(
                hintText: "Create Strong Password",
                height: 56,
                width: 380,
                prefixicon: Icon(Icons.lock_outline),
                controller: password,
                eyebutton: true,
                hideText: true,
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Forgot password?",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1D6FB8),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 40),
              Button(
                height: 56,
                width: 380,
                text: "Register",
                onpressed: ()=>validateInput(),
              ),
              const SizedBox(height: 18),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Already have an account? ",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    TextSpan(
                      text: "Login Now",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1D6FB8),
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pop(context);
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}