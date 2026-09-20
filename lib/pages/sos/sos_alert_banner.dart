import 'package:flutter/material.dart';

import './sos_page.dart' show SosColors;

class SosAlertBanner extends StatelessWidget {
  final bool active;

  const SosAlertBanner({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    final c = SosColors.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.4,
          colors: [
            c.red.withValues(alpha: 0.28),
            c.redDark,
          ],
        ),
        border: Border.all(color: c.red.withValues(alpha: 0.35)),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c.red.withValues(alpha: 0.15),
            ),
            child: Icon(
              Icons.notifications_active,
              color: c.red,
              size: 34,
            ),
          ),
          const SizedBox(height: 14),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
              children: [
                TextSpan(
                  text: "EMERGENCY ",
                  style: TextStyle(color: c.textPrimary),
                ),
                TextSpan(
                  text: "SOS",
                  style: TextStyle(color: c.red),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Your location and details will be shared\nwith emergency services.",
            textAlign: TextAlign.center,
            style: TextStyle(color: c.textSecondary, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }
}
