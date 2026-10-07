import 'package:flutter/material.dart';

Future<String?> showAddSosEmailDialog(BuildContext context) async {
  final controller = TextEditingController();

  try {
    return await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add SOS Email'),
          content: TextField(
            controller: controller,
            autofocus: false,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Email address',
              hintText: 'example@gmail.com',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              final email = value.trim();

              if (email.isNotEmpty) {
                Navigator.pop(dialogContext);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final email = controller.text.trim();

                if (email.isEmpty) {
                  return;
                }

                Navigator.of(dialogContext).pop(email);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  } finally {
    controller.dispose();
  }
}

Future<bool> showDeleteSosEmailDialog(
  BuildContext context,
  String email,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
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
