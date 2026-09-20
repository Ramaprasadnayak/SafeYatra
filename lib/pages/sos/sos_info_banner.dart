import 'package:flutter/material.dart';

import './sos_page.dart' show SosColors;

class SosInfoBanner extends StatelessWidget {
  final String text;

  const SosInfoBanner({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final c = SosColors.of(context);

    return Row(
      children: [
        Icon(Icons.info_outline, size: 16, color: c.blue),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(color: c.textSecondary, fontSize: 12.5),
        ),
      ],
    );
  }
}
