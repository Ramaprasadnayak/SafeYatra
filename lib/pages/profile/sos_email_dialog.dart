import 'package:flutter/material.dart';

/// Shows a dialog to add an SOS email.
/// Returns the trimmed email, or null if cancelled.
Future<String?> showAddSosEmailDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (_) => const _AddSosEmailDialog(),
  );
}

Future<bool> showDeleteSosEmailDialog(
  BuildContext context,
  String email,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Delete Email'),
        content: Text('Are you sure you want to delete\n$email?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );

  return confirmed == true;
}
class _AddSosEmailDialog extends StatefulWidget {
  const _AddSosEmailDialog();

  @override
  State<_AddSosEmailDialog> createState() => _AddSosEmailDialogState();
}

class _AddSosEmailDialogState extends State<_AddSosEmailDialog> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  static final RegExp _emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final email = _controller.text.trim();

    if (email.isEmpty) {
      setState(() => _errorText = 'Please enter an email address');
      return;
    }

    if (!_emailRegex.hasMatch(email)) {
      setState(() => _errorText = 'Please enter a valid email address');
      return;
    }

    Navigator.of(context).pop(email);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add SOS Email'),
      content: TextField(
        controller: _controller,
        autofocus: false,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        onChanged: (_) {
          if (_errorText != null) {
            setState(() => _errorText = null);
          }
        },
        onSubmitted: (_) => _submit(),
        decoration: InputDecoration(
          labelText: 'Email address',
          hintText: 'example@gmail.com',
          border: const OutlineInputBorder(),
          errorText: _errorText,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Add'),
        ),
      ],
    );
  }
}