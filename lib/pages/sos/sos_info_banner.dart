import 'package:flutter/material.dart';
import '../sos_page.dart' show SosColors;

/// Small reassurance banner shown at the bottom of the page.
class SosInfoBanner extends StatelessWidget {
  final String text;

  const SosInfoBanner({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.info_outline, size: 16, color: SosColors.blue),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(color: SosColors.textSecondary, fontSize: 12.5),
        ),
      ],
    );
  }
}
