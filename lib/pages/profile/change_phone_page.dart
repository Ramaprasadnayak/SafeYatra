import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safeyatra/pages/profile/auth_service.dart';

class ChangePhonePage extends StatefulWidget {
  const ChangePhonePage({super.key});

  @override
  State<ChangePhonePage> createState() => _ChangePhonePageState();
}

class _ChangePhonePageState extends State<ChangePhonePage> {
  static const _countryCode = '+91'; // change if needed

  final _phoneCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  String? _verificationId;
  bool _loading = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _sendOtp() async {
    final digits = _phoneCtrl.text.trim();
    if (digits.length != 10) {
      _toast('Enter a valid 10-digit phone number');
      return;
    }
    setState(() => _loading = true);
    await AuthService.instance.sendPhoneOtp(
      phoneNumber: '$_countryCode$digits',
      onCodeSent: (id) {
        if (!mounted) return;
        setState(() {
          _verificationId = id;
          _loading = false;
        });
        _toast('OTP sent');
      },
      onError: (message) {
        if (!mounted) return;
        setState(() => _loading = false);
        _toast(message);
      },
    );
  }

  Future<void> _verify() async {
    final otp = _otpCtrl.text.trim();
    if (otp.length != 6) {
      _toast('Enter the 6-digit OTP');
      return;
    }
    setState(() => _loading = true);
    try {
      await AuthService.instance
          .updatePhone(verificationId: _verificationId!, smsCode: otp);
      if (!mounted) return;
      _toast('Phone number updated');
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      _toast(e.message ?? 'Verification failed');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final otpSent = _verificationId != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Change Phone Number')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _phoneCtrl,
              enabled: !otpSent,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'New phone number',
                prefixText: '$_countryCode ',
                border: OutlineInputBorder(),
              ),
            ),
            if (otpSent) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _otpCtrl,
                keyboardType: TextInputType.number,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Enter OTP',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: _loading ? null : (otpSent ? _verify : _sendOtp),
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(otpSent ? 'Verify & Update' : 'Send OTP'),
              ),
            ),
            if (otpSent)
              TextButton(
                onPressed: _loading
                    ? null
                    : () => setState(() {
                          _verificationId = null;
                          _otpCtrl.clear();
                        }),
                child: const Text('Change number'),
              ),
          ],
        ),
      ),
    );
  }
}
