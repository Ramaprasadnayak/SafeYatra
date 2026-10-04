import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safeyatra/core/constants/number.dart';
import 'package:safeyatra/pages/auth/otp_page.dart';
import 'package:safeyatra/widgets/buttons.dart';
import 'package:safeyatra/services/otpservice.dart';
import 'package:safeyatra/widgets/drop_down_button.dart';
import 'package:safeyatra/widgets/text_field.dart';

class PhonePage extends StatefulWidget {
  final String usrname, email, password;
  final BuildContext context;

  const PhonePage({
    super.key,
    required this.usrname,
    required this.email,
    required this.password,
    required this.context,
  });

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  final TextEditingController phno = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendOtp() async {
    final rawNumber = phno.text.trim();

    if (rawNumber.isEmpty || rawNumber.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid phone number")),
      );
      return;
    }
    // Assumes Indian numbers; prepend +91 if not already present.
    final phoneNumber = rawNumber.startsWith('+') ? rawNumber : '+91$rawNumber';

    setState(() => _isLoading = true);
    final sent = await sendOtp(context, phoneNumber);
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (sent) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpPage(
            usrname: widget.usrname,
            email: widget.email,
            password: widget.password,
            phoneNumber: phoneNumber,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    phno.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fieldWidth = MediaQuery.of(context).size.width.clamp(0, 380) - 40;

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
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Phone number verification",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 40),
                MyTextField(
                  hintText: "Enter Phone number",
                  height: 56,
                  enablefocus: false,
                  width: fieldWidth.toDouble(),
                  prefixicon: MyDropdownMenu(
                    value: "+91",
                    onChange: (s) {},
                    height: 200,
                    width: 115,
                    mylist: numbers,
                  ),
                  controller: phno,
                  eyebutton: false,
                  hideText: false,
                ),
                const SizedBox(height: 40),
                _isLoading
                    ? const CircularProgressIndicator()
                    : Button(
                        height: 56,
                        width: fieldWidth.toDouble(),
                        text: "send otp",
                        onpressed: _sendOtp,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}