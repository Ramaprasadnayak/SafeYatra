import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safeyatra/services/login_register.dart';
import 'package:safeyatra/widgets/buttons.dart';

class EmailPage extends StatefulWidget {
  final String usrname;
  final String email;
  final String password;

  const EmailPage({
    super.key,
    required this.usrname,
    required this.email,
    required this.password,
  });

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> with WidgetsBindingObserver {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Timer? _pollTimer;
  Timer? _cooldownTimer;
  Timer? _verifyCooldownTimer;

  bool _isLoading = true;
  bool _isChecking = false;
  bool _checkInFlight = false;
  bool _isLeaving = false;
  bool _isCompletingRegistration = false;
  bool _registrationCompleted = false;

  int _cooldown = 0;
  int _verifyCooldown = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _registerAndSend();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pollTimer?.cancel();
    _cooldownTimer?.cancel();
    _verifyCooldownTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        !_isLoading &&
        !_isLeaving &&
        !_registrationCompleted) {
      _checkVerified(silent: true);
    }
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _stopTimers() {
    _pollTimer?.cancel();
    _cooldownTimer?.cancel();
    _verifyCooldownTimer?.cancel();
  }

  Future<void> _registerAndSend() async {
    try {
      final success = await register(
        widget.usrname,
        widget.email,
        widget.password,
        context,
      );

      if (!mounted) return;

      if (!success) {
        Navigator.of(context).pop();
        return;
      }

      final user = _auth.currentUser;

      if (user == null) {
        _snack('Unable to access your account. Please try again.');
        Navigator.of(context).pop();
        return;
      }

      await user.reload();

      if (_auth.currentUser?.emailVerified ?? false) {
        await _onVerified();
        return;
      }

      _startCooldown();
      _startPolling();
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        _snack(e.message ?? 'Could not send verification email.');
        if (_auth.currentUser != null) _startPolling();
      }
    } catch (e) {
      if (mounted) {
        _snack('Something went wrong. Please try again.');
        debugPrint('Email registration error: $e');
        if (_auth.currentUser != null) _startPolling();
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _checkVerified(silent: true),
    );
  }

  void _startCooldown() {
    _cooldownTimer?.cancel();

    if (!mounted) return;

    setState(() => _cooldown = 60);

    _cooldownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (_cooldown <= 1) {
          timer.cancel();
          setState(() => _cooldown = 0);
        } else {
          setState(() => _cooldown--);
        }
      },
    );
  }

  void _startVerifyCooldown([int seconds = 5]) {
    _verifyCooldownTimer?.cancel();

    if (!mounted) return;

    setState(() => _verifyCooldown = seconds);

    _verifyCooldownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (_verifyCooldown <= 1) {
          timer.cancel();
          setState(() => _verifyCooldown = 0);
        } else {
          setState(() => _verifyCooldown--);
        }
      },
    );
  }

  Future<void> _checkVerified({bool silent = false}) async {
    if (_checkInFlight || _isCompletingRegistration || _isLeaving) return;
    if (!silent && _verifyCooldown > 0) return;

    _checkInFlight = true;

    if (!silent) {
      _startVerifyCooldown();
      if (mounted) setState(() => _isChecking = true);
    }

    try {
      await _auth.currentUser?.reload();

      if (!mounted) return;

      final user = _auth.currentUser;

      if (user == null) {
        _stopTimers();
        if (!silent) {
          _snack('Your session has expired. Please sign in again.');
        }
        return;
      }

      if (user.emailVerified) {
        await _onVerified();
        return;
      }

      if (!silent) {
        _snack('Email not verified yet. Please check your inbox.');
      }
    } on FirebaseAuthException catch (e) {
      if (!silent) {
        _snack(e.message ?? 'Could not check email verification.');
      }
    } catch (e) {
      if (!silent) {
        _snack('Unable to check verification. Please try again.');
      }
      debugPrint('Verification check error: $e');
    } finally {
      _checkInFlight = false;
      if (mounted && !silent) {
        setState(() => _isChecking = false);
      }
    }
  }

  Future<void> _resend() async {
    if (_cooldown > 0 || _isCompletingRegistration || _isLeaving) return;

    try {
      final user = _auth.currentUser;

      if (user == null) {
        _snack('Unable to access your account. Please try again.');
        return;
      }

      await user.reload();

      final refreshedUser = _auth.currentUser;

      if (refreshedUser == null) {
        _snack('Unable to access your account.');
        return;
      }

      if (refreshedUser.emailVerified) {
        await _onVerified();
        return;
      }

      await refreshedUser.sendEmailVerification();

      if (!mounted) return;

      _startCooldown();
      _snack('Verification email sent.');
    } on FirebaseAuthException catch (e) {
      _snack(e.message ?? 'Could not resend verification email.');
    } catch (e) {
      _snack('Something went wrong. Please try again.');
      debugPrint('Resend verification error: $e');
    }
  }

  Future<void> _onVerified() async {
    if (!mounted || _isCompletingRegistration || _registrationCompleted) {
      return;
    }

    _isCompletingRegistration = true;
    _stopTimers();

    if (mounted) {
      setState(() {
        _isChecking = false;
        _verifyCooldown = 0;
        _cooldown = 0;
      });
    }

    try {
      await _auth.currentUser?.reload();

      if (!mounted) return;

      final user = _auth.currentUser;

      if (user == null || !user.emailVerified) {
        _snack('Email verification could not be confirmed.');
        _startPolling();
        return;
      }

      final success = await completeRegistration();

      if (!mounted) return;

      if (!success) {
        _snack(
          'Email verified, but account registration failed. '
          'Tap "I have verified" to retry.',
        );
        return;
      }

      _registrationCompleted = true;

      _snack('Email verified and registration completed!');

      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      _snack('Could not complete registration. Please try again.');
      debugPrint('Complete registration error: $e');
    } finally {
      _isCompletingRegistration = false;
      if (mounted) setState(() {});
    }
  }

  Future<void> _abandon() async {
    final user = _auth.currentUser;

    try {
      if (user != null && !user.emailVerified) {
        await user.delete();
      }
    } catch (e) {
      debugPrint('Could not delete unverified user: $e');
    }

    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('Sign out error: $e');
    }
  }

  Future<void> _handleBack() async {
    if (_isLeaving || _isCompletingRegistration || _checkInFlight) return;

    try {
      await _auth.currentUser?.reload();
    } catch (e) {
      debugPrint('Reload on back error: $e');
    }

    if (!mounted) return;

    if (_auth.currentUser?.emailVerified ?? false) {
      await _onVerified();
      return;
    }

    setState(() => _isLeaving = true);
    _stopTimers();

    await _abandon();

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fieldWidth = (screenWidth - 40).clamp(0.0, 380.0);
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    final busy = _isChecking || _isCompletingRegistration;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Safe ',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                TextSpan(
                  text: 'Yatra',
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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 32),
              child: (_isLoading || _isLeaving)
                  ? const CircularProgressIndicator()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.mark_email_unread_outlined,
                          size: 76,
                          color: Color(0xFF1D6FB8),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Verify your email',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'We sent a verification link to\n${widget.email}\n\n'
                          'Open the email and tap the verification link. '
                          'Then return to SafeYatra.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            height: 1.7,
                          ),
                        ),
                        const SizedBox(height: 36),
                        SizedBox(
                          width: fieldWidth,
                          child: busy
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Button(
                                  height: 56,
                                  width: fieldWidth,
                                  text: _verifyCooldown > 0
                                      ? 'Check again in ${_verifyCooldown}s'
                                      : 'I have verified',
                                  onpressed: _verifyCooldown > 0
                                      ? () {}
                                      : () => _checkVerified(),
                                ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: (_cooldown > 0 || busy) ? null : _resend,
                          child: Text(
                            _cooldown > 0
                                ? 'Resend email in ${_cooldown}s'
                                : 'Resend email',
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Your account will be registered only after '
                          'your email is verified.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}