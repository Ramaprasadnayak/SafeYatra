import 'package:flutter/material.dart';
import './sos_page.dart' show SosColors;

/// "Your Emergency Contacts" row with a "View Contacts" button.
class SosEmergencyContactsCard extends StatelessWidget {
  final VoidCallback onViewContacts;

  const SosEmergencyContactsCard({super.key, required this.onViewContacts});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SosColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: SosColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFF3A2E6B),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.people_outline, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Your Emergency Contacts",
                  style: TextStyle(
                    color: SosColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Will be notified with your location and incident details.",
                  style: TextStyle(color: SosColors.textSecondary, fontSize: 11.5, height: 1.3),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onViewContacts,
            style: TextButton.styleFrom(
              backgroundColor: SosColors.blue.withOpacity(0.15),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "View Contacts",
                  style: TextStyle(color: SosColors.blue, fontSize: 12.5, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 14, color: SosColors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
