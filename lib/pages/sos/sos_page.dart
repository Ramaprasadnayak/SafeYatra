import 'package:flutter/material.dart';
import 'package:safeyatra/pages/sos/sos_alert_banner.dart';
import 'package:safeyatra/pages/sos/sos_call_button.dart';
import 'package:safeyatra/pages/sos/sos_location_card.dart';
import 'package:safeyatra/pages/sos/sos_info_banner.dart';
@immutable
class SosColors extends ThemeExtension<SosColors> {
  final Color background;
  final Color card;
  final Color cardBorder;
  final Color red;
  final Color redDark; 
  final Color green;
  final Color blue;
  final Color textPrimary;
  final Color textSecondary;
  final Color mapBackground;
  final Color mapLine;

  const SosColors({
    required this.background,
    required this.card,
    required this.cardBorder,
    required this.red,
    required this.redDark,
    required this.green,
    required this.blue,
    required this.textPrimary,
    required this.textSecondary,
    required this.mapBackground,
    required this.mapLine,
  });

  static const dark = SosColors(
    background: Color(0xFF0A0E1A),
    card: Color(0xFF131A2C),
    cardBorder: Color(0xFF232B3E),
    red: Color(0xFFE53E3E),
    redDark: Color(0xFF3A1418),
    green: Color(0xFF34C759),
    blue: Color(0xFF3B82F6),
    textPrimary: Colors.white,
    textSecondary: Color(0xFF8B93A7),
    mapBackground: Color(0xFF0D1424),
    mapLine: Color(0x0FFFFFFF), // white @ ~6%
  );

  static const light = SosColors(
    background: Color(0xFFF5F7FB),
    card: Colors.white,
    cardBorder: Color(0xFFE2E6EF),
    red: Color(0xFFE53E3E),
    redDark: Color(0xFFFDE8E8),
    green: Color(0xFF28A745),
    blue: Color(0xFF2563EB),
    textPrimary: Color(0xFF111827),
    textSecondary: Color(0xFF6B7280),
    mapBackground: Color(0xFFE8EDF5),
    mapLine: Color(0x1F000000), // black @ ~12%
  );

  /// Falls back to the palette matching the current brightness if the
  /// extension was not registered on the ThemeData.
  static SosColors of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<SosColors>() ??
        (theme.brightness == Brightness.dark ? dark : light);
  }

  @override
  SosColors copyWith({
    Color? background,
    Color? card,
    Color? cardBorder,
    Color? red,
    Color? redDark,
    Color? green,
    Color? blue,
    Color? textPrimary,
    Color? textSecondary,
    Color? mapBackground,
    Color? mapLine,
  }) {
    return SosColors(
      background: background ?? this.background,
      card: card ?? this.card,
      cardBorder: cardBorder ?? this.cardBorder,
      red: red ?? this.red,
      redDark: redDark ?? this.redDark,
      green: green ?? this.green,
      blue: blue ?? this.blue,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      mapBackground: mapBackground ?? this.mapBackground,
      mapLine: mapLine ?? this.mapLine,
    );
  }

  @override
  SosColors lerp(ThemeExtension<SosColors>? other, double t) {
    if (other is! SosColors) return this;
    return SosColors(
      background: Color.lerp(background, other.background, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      red: Color.lerp(red, other.red, t)!,
      redDark: Color.lerp(redDark, other.redDark, t)!,
      green: Color.lerp(green, other.green, t)!,
      blue: Color.lerp(blue, other.blue, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      mapBackground: Color.lerp(mapBackground, other.mapBackground, t)!,
      mapLine: Color.lerp(mapLine, other.mapLine, t)!,
    );
  }
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
    final hour = activatedAt.hour % 12 == 0 ? 12 : activatedAt.hour % 12;
    final minute = activatedAt.minute.toString().padLeft(2, '0');
    final period = activatedAt.hour >= 12 ? "PM" : "AM";
    return "$hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    final c = SosColors.of(context);

    return Container(
      color: c.background,
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
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            const SosInfoBanner(text: "Stay calm. Help is on the way."),
          ],
        ),
      ),
    );
  }
}
