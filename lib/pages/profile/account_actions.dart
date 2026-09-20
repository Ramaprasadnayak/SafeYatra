import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safeyatra/pages/profile/auth_service.dart';

const _loginRoute = '/login'; // change to your login route

void _goToLogin(BuildContext context) {
  Navigator.of(context, rootNavigator: true)
      .pushNamedAndRemoveUntil(_loginRoute, (route) => false);
}

Future<void> confirmLogout(BuildContext context) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to log out?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Logout'),
        ),
      ],
    ),
  );
  if (ok != true) return;

  await AuthService.instance.signOut();
  if (!context.mounted) return;
  _goToLogin(context);
}

Future<void> confirmDeleteAccount(BuildContext context) async {
  final password = await showDialog<String>(
    context: context,
    builder: (_) => const _DeleteAccountDialog(),
  );
  if (password == null || password.isEmpty) return;

  try {
    await AuthService.instance.deleteAccount(password);
    if (!context.mounted) return;
    _goToLogin(context);
  } on FirebaseAuthException catch (e) {
    if (!context.mounted) return;
    final wrong = e.code == 'wrong-password' || e.code == 'invalid-credential';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(wrong ? 'Incorrect password' : (e.message ?? 'Could not delete account'))),
    );
  }
}

class _DeleteAccountDialog extends StatefulWidget {
  const _DeleteAccountDialog();

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete account'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This permanently deletes your account and cannot be undone. '
            'Enter your password to confirm.',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _ctrl,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          onPressed: () => Navigator.pop(context, _ctrl.text),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
