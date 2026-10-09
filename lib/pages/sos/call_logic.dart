import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openDialer112(BuildContext context) async {
  final uri = Uri(scheme: 'tel', path: '112');

  try {
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Couldn't open the dialer"),
        ),
      );
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Couldn't open the dialer"),
        ),
      );
    }
  }
}

Future<void> confirmAndCall112(BuildContext context) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text("Call 112?"),
      content: const Text(
        "This will open your phone dialer with 112.",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text("OK"),
        ),
      ],
    ),
  );

  if (ok == true && context.mounted) {
    await openDialer112(context);
  }
}