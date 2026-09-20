import 'package:flutter/material.dart';
import './sos_page.dart' show SosColors;
import 'sos_map_preview.dart';

class SosLocationCard extends StatelessWidget {
  final String locality;
  final String district;
  final String coordinates;
  final bool active;
  final String activatedAtLabel;

  const SosLocationCard({
    super.key,
    required this.locality,
    required this.district,
    required this.coordinates,
    required this.active,
    required this.activatedAtLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SosColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: SosColors.cardBorder),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: SosColors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.location_on, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Your Current Location",
                      style: TextStyle(color: SosColors.textSecondary, fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      locality,
                      style: const TextStyle(
                        color: SosColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      district,
                      style: const TextStyle(color: SosColors.textSecondary, fontSize: 12.5),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.my_location, size: 12, color: SosColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          coordinates,
                          style: const TextStyle(color: SosColors.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _SosActivePill(active: active, timeLabel: activatedAtLabel),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              height: 210,
              width: double.infinity,
              child: SosMapPreview(centerLabel: locality),
            ),
          ),
        ],
      ),
    );
  }
}
class _SosActivePill extends StatelessWidget {
  final bool active;
  final String timeLabel;

  const _SosActivePill({
    required this.active,
    required this.timeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: SosColors.redDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: SosColors.red.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                margin: const EdgeInsets.only(right: 5),
                decoration: const BoxDecoration(
                  color: SosColors.red,
                  shape: BoxShape.circle,
                ),
              ),

              Text(
                active ? "SOS Active" : "SOS Ended",
                style: const TextStyle(
                  color: SosColors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 2),

          Text(
            timeLabel,
            style: const TextStyle(
              color: SosColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}