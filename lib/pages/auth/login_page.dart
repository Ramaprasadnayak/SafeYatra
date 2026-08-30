import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safeyatra/pages/auth/register_page.dart';
// import 'package:safeyatra/features/home_screen.dart';
import 'package:safeyatra/services/login_register.dart';
import 'package:safeyatra/widgets/buttons.dart';
import 'package:safeyatra/widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void validateInput(){
      if (email.text.isEmpty || password.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Textfield cant be empty"),
            duration: Duration(seconds: 2),
          ),
        );
      }
      else if (email.text.trim().length < 6 || password.text.trim().length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Must contain at least 6 characters"),
          ),
        );
      }
      else if (!email.text.trim().endsWith("@gmail.com")) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid email"),
          ),
        );
      }
      else{
        login(email.text.trim(), password.text.trim(),context);
      }
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
          child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                Text(
                  "Login to your account",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 30),
                MyTextField(
                  hintText: "Enter Email",
                  height: 56,
                  width: 380,
                  prefixicon: Icon(Icons.person_outline),
                  controller: email,
                  eyebutton: false, 
                  hideText: false,
                ),
                const SizedBox(height: 20),
                MyTextField(
                  hintText: "Enter Password",
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
                  text: "Login",
                  onpressed: ()=>validateInput()
                ),
                const SizedBox(height: 18),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't have an account? ",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                      TextSpan(
                        text: "Register Now",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1D6FB8),
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
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