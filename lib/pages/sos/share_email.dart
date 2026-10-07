import 'package:flutter/material.dart';

import './sos_page.dart' show SosColors;
import 'email_service.dart';

class ShareEmail extends StatefulWidget {
  final String locality;
  final String district;
  final String coordinates;
  final double? latitude;
  final double? longitude;

  const ShareEmail({
    super.key,
    required this.locality,
    required this.district,
    required this.coordinates,
    this.latitude,
    this.longitude,
  });

  @override
  State<ShareEmail> createState() => _ShareEmailState();
}

class _ShareEmailState extends State<ShareEmail> {
  bool _sending = false;

  Future<void> _onTap() async {
    if (_sending) return;
    final c = SosColors.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: c.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: c.red),
            const SizedBox(width: 8),
            Text('Emergency SOS',
                style: TextStyle(
                    color: c.textPrimary, fontWeight: FontWeight.w700)),
          ],
        ),
        content: Text(
          'Your location details will be sent to all your emergency contacts by email. Continue?',
          style: TextStyle(color: c.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: c.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('OK',
                style: TextStyle(color: c.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _sending = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final count = await EmailService.sendSosAlert(
        locality: widget.locality,
        district: widget.district,
        coordinates: widget.coordinates,
        latitude: widget.latitude,
        longitude: widget.longitude,
      );
      messenger.showSnackBar(SnackBar(
        content: Text('SOS sent to $count emergency contact(s)'),
        backgroundColor: c.green,
      ));
    } catch (e) {
      messenger.showSnackBar(SnackBar(
        content: Text(e.toString().replaceFirst('Exception: ', '')),
        backgroundColor: c.red,
      ));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = SosColors.of(context);

    return Material(
      color: c.card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: _onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: c.cardBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: c.blue.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: _sending
                    ? Padding(
                        padding: const EdgeInsets.all(12),
                        child: CircularProgressIndicator(
                            strokeWidth: 2.5, color: c.blue),
                      )
                    : Icon(Icons.email_outlined, color: c.blue, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ALERT EMERGENCY CONTACTS',
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Email your live location to saved contacts',
                      style: TextStyle(color: c.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: c.textSecondary, size: 26),
            ],
          ),
        ),
      ),
    );
  }
}