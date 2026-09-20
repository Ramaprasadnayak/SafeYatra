import 'package:flutter/material.dart';
import 'package:safeyatra/pages/sos/sos_alert_banner.dart';
import 'package:safeyatra/pages/sos/sos_call_button.dart';
import 'package:safeyatra/pages/sos/sos_location_card.dart';
import 'package:safeyatra/pages/sos/sos_info_banner.dart';

class SosColors {
  static const background = Color(0xFFF5F7FA);
  static const card = Colors.white;
  static const cardBorder = Color(0xFFE2E5EA);

  static const red = Color(0xFFE53935);
  static const redDark = Color(0xFFFFE8E7);

  static const green = Color(0xFF34C759);
  static const blue = Color(0xFF2563EB);

  static const textPrimary = Color(0xFF171A21);
  static const textSecondary = Color(0xFF6B7280);
}

class EmergencyService {
  final String label;
  final IconData icon;
  final Color iconBackground;
  final bool notified;

  const EmergencyService({
    required this.label,
    required this.icon,
    required this.iconBackground,
    this.notified = true,
  });
}

class SosPage extends StatefulWidget {
  final VoidCallback? onCallEmergency;
  final VoidCallback? onViewContacts;
  final String locality;
  final String district;
  final String coordinates;

  const SosPage({
    super.key,
    this.onCallEmergency,
    this.onViewContacts,
    this.locality = "Koramangala",
    this.district = "Bengaluru Urban District, Karnataka",
    this.coordinates = "13.0123° N, 77.6245° E",
  });

  @override
  State<SosPage> createState() => _SosPageState();
}

class _SosPageState extends State<SosPage> {
  bool sosActive = true;

  late final DateTime activatedAt = DateTime.now();

  String get _formattedTime {
    final hour = activatedAt.hour % 12 == 0
        ? 12
        : activatedAt.hour % 12;

    final minute = activatedAt.minute.toString().padLeft(2, '0');

    final period = activatedAt.hour >= 12 ? "PM" : "AM";

    return "$hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SosColors.background,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            SosAlertBanner(active: sosActive),

            const SizedBox(height: 16),

            SosLocationCard(
              locality: widget.locality,
              district: widget.district,
              coordinates: widget.coordinates,
              active: sosActive,
              activatedAtLabel: _formattedTime,
            ),

            const SizedBox(height: 16),

            SosCallButton(
              onTap: widget.onCallEmergency ?? () {},
            ),

            const SizedBox(height: 16),

            const SosInfoBanner(
              text: "Stay calm. Help is on the way.",
            ),
          ],
        ),
      ),
    );
  }
}