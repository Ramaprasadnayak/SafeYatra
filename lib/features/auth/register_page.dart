import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    void validateInput(){
      if (usrname.text.isEmpty || password.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Textfield cant be empty"),
            duration: Duration(seconds: 2),
          ),
        );
      }
      else if (usrname.text.trim().length < 8 || password.text.trim().length < 8) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Must contain at least 8 characters"),
            duration: Duration(seconds: 2),
          ),
        );
      }
      else if (email.text.trim().endsWith("@gmail.com")) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("gmail must end with @gmail.com"),
            duration: Duration(seconds: 2),
          ),
        );
      }
      else if(!verifyuser(username.text.trim(), context)){

      }
      else{
        register(usrname.text.trim(),email.text.trim(),password.text.trim(),context);
      }
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
                prefixicon: Icons.person_outline,
                controller: usrname,
                eyebutton: false,
                hideText: false,
              ),
              const SizedBox(height: 20),
              MyTextField(
                hintText: "Choose a email",
                height: 56,
                width: 380,
                prefixicon: Icons.email_outlined,
                controller: email,
                eyebutton: false,
                hideText: false,
              ),
              const SizedBox(height: 20),
              MyTextField(
                hintText: "Create Strong Password",
                height: 56,
                width: 380,
                prefixicon: Icons.lock_outline,
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