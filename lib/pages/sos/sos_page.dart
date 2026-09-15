import 'package:flutter/material.dart';

import 'widgets/sos_alert_banner.dart';
import 'widgets/sos_location_card.dart';
import 'widgets/sos_call_button.dart';
import 'widgets/sos_services_notified.dart';
import 'widgets/sos_emergency_contacts_card.dart';
import 'widgets/sos_info_banner.dart';

/// Colors reused across the SOS feature. Pulled out here so every
/// widget in this folder stays visually consistent.
class SosColors {
  static const background = Color(0xFF0A0E1A);
  static const card = Color(0xFF131A2C);
  static const cardBorder = Color(0xFF232B3E);
  static const red = Color(0xFFE53E3E);
  static const redDark = Color(0xFF3A1418);
  static const green = Color(0xFF34C759);
  static const blue = Color(0xFF3B82F6);
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFF8B93A7);
}

/// A single emergency service entry, e.g. Police / Ambulance / Fire.
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
  /// Called when the person taps "Call 112". Wire this up to
  /// url_launcher (tel:112) or your own dialer integration.
  final VoidCallback? onCallEmergency;

  /// Called when "View Contacts" is tapped.
  final VoidCallback? onViewContacts;

  /// Optional: pass real coordinates/address once you have a
  /// location service wired up. Falls back to placeholder data.
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
  // In a real app this would flip to true the moment the SOS is
  // triggered (e.g. from a home-screen SOS button) and the
  // activatedAt timestamp would be captured then.
  bool sosActive = true;
  late final DateTime activatedAt = DateTime.now();

  static const services = [
    EmergencyService(
      label: "Police",
      icon: Icons.shield_outlined,
      iconBackground: SosColors.blue,
    ),
    EmergencyService(
      label: "Ambulance",
      icon: Icons.local_shipping_outlined,
      iconBackground: Color(0xFF7A2020),
    ),
    EmergencyService(
      label: "Fire",
      icon: Icons.local_fire_department_outlined,
      iconBackground: Color(0xFF9A5B12),
    ),
    EmergencyService(
      label: "Disaster Mgmt",
      icon: Icons.warning_amber_outlined,
      iconBackground: Color(0xFF4A3B7A),
    ),
  ];

  String get _formattedTime {
    final hour = activatedAt.hour % 12 == 0 ? 12 : activatedAt.hour % 12;
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
            SosServicesNotified(services: services),
            const SizedBox(height: 16),
            SosEmergencyContactsCard(
              onViewContacts: widget.onViewContacts ?? () {},
            ),
            const SizedBox(height: 16),
            const SosInfoBanner(text: "Stay calm. Help is on the way."),
          ],
        ),
      ),
    );
  }
}
