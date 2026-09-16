import 'package:flutter/material.dart';
import './sos_page.dart' show SosColors, EmergencyService;

/// "Emergency Services Notified" card with a 4-across grid of
/// service icons and their notified status.
class SosServicesNotified extends StatelessWidget {
  final List<EmergencyService> services;

  const SosServicesNotified({super.key, required this.services});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Emergency Services Notified",
            style: TextStyle(
              color: SosColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: services.map((s) => _ServiceTile(service: s)).toList(),
          ),
        ],
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final EmergencyService service;

  const _ServiceTile({required this.service});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: service.iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(service.icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            service.label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: SosColors.textPrimary, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                service.notified ? Icons.check_circle : Icons.hourglass_bottom,
                size: 12,
                color: service.notified ? SosColors.green : SosColors.textSecondary,
              ),
              const SizedBox(width: 3),
              Text(
                service.notified ? "Notified" : "Pending",
                style: TextStyle(
                  fontSize: 10.5,
                  color: service.notified ? SosColors.green : SosColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
