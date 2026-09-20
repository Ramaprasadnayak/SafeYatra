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
    final c = SosColors.of(context);

    return Container(
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.cardBorder),
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
                decoration: BoxDecoration(
                  color: c.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.location_on, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Current Location",
                      style: TextStyle(color: c.textSecondary, fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      locality,
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      district,
                      style: TextStyle(color: c.textSecondary, fontSize: 12.5),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.my_location, size: 12, color: c.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          coordinates,
                          style: TextStyle(color: c.textSecondary, fontSize: 12),
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

  const _SosActivePill({required this.active, required this.timeLabel});

  @override
  Widget build(BuildContext context) {
    final c = SosColors.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: c.redDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.red.withValues(alpha: 0.4)),
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
                decoration: BoxDecoration(color: c.red, shape: BoxShape.circle),
              ),
              Text(
                active ? "SOS Active" : "SOS Ended",
                style: TextStyle(
                  color: c.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            timeLabel,
            style: TextStyle(color: c.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
