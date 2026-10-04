import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safeyatra/services/login_register.dart';
import 'package:safeyatra/widgets/buttons.dart';

class EmailPage extends StatefulWidget {
  final String usrname, email, password;

  const EmailPage({
    super.key,
    required this.usrname,
    required this.email,
    required this.password,
  });

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Timer? _pollTimer;
  Timer? _cooldownTimer;

  bool _isLoading = true;
  bool _isChecking = false;
  int _cooldown = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _registerAndSend());
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _registerAndSend() async {
    // register() shows its own error snackbars and returns false on failure.
    final ok = await register(
      widget.usrname,
      widget.email,
      widget.password,
      context,
    );

    if (!mounted) return;

    if (!ok) {
      Navigator.pop(context); // back to the register form
      return;
    }

    try {
      final user = _auth.currentUser;
      if (user != null && user.emailVerified) {
        _onVerified();
        return;
      }
      await user?.sendEmailVerification();
      _startCooldown();
      _startPolling();
    } on FirebaseAuthException catch (e) {
      _snack(e.message ?? "Could not send verification email");
    } catch (_) {
      _snack("Something went wrong. Please try again.");
    }

    if (mounted) setState(() => _isLoading = false);
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _checkVerified(silent: true);
    });
  }

  void _startCooldown() {
    _cooldownTimer?.cancel();
    setState(() => _cooldown = 60);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_cooldown <= 1) {
        t.cancel();
      }
      if (mounted) setState(() => _cooldown = _cooldown > 0 ? _cooldown - 1 : 0);
    });
  }

  Future<void> _checkVerified({bool silent = false}) async {
    if (!silent) setState(() => _isChecking = true);
    try {
      await _auth.currentUser?.reload();
      final user = _auth.currentUser;
      if (user != null && user.emailVerified) {
        _onVerified();
        return;
      }
      if (!silent) _snack("Email not verified yet. Check your inbox.");
    } on FirebaseAuthException catch (e) {
      if (!silent) _snack(e.message ?? "Could not check verification");
    } finally {
      if (!silent && mounted) setState(() => _isChecking = false);
    }
  }

  Future<void> _resend() async {
    if (_cooldown > 0) return;
    try {
      await _auth.currentUser?.sendEmailVerification();
      _startCooldown();
      _snack("Verification email sent");
    } on FirebaseAuthException catch (e) {
      _snack(e.message ?? "Could not resend email");
    }
  }

  void _onVerified() {
    _pollTimer?.cancel();
    _cooldownTimer?.cancel();
    if (!mounted) return;
    _snack("Email verified!");
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _cooldownTimer?.cancel();
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
            child: _isLoading
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.mark_email_unread_outlined,
                        size: 72,
                        color: Color(0xFF1D6FB8),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Verify your email",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "We sent a verification link to\n${widget.email}\n\n"
                          "Tap the link in the email, then come back here.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                      const SizedBox(height: 40),
                      _isChecking
                          ? const CircularProgressIndicator()
                          : Button(
                              height: 56,
                              width: fieldWidth.toDouble(),
                              text: "I've verified",
                              onpressed: () => _checkVerified(),
                            ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: _cooldown > 0 ? null : _resend,
                        child: Text(
                          _cooldown > 0
                              ? "Resend email in ${_cooldown}s"
                              : "Resend email",
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
