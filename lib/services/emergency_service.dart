import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyService {
  static const String emergencyNumber = '112';
  static Future<bool> callEmergency(BuildContext context) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: emergencyNumber);

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
        return true;
      } else {
        if (context.mounted) {
          _showError(context, 'Cannot make phone calls on this device');
        }
        return false;
      }
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Failed to initiate emergency call: $e');
      }
      return false;
    }
  }

  static Future<bool> callEmergencyWithConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.red, size: 28),
              SizedBox(width: 12),
              Text('Call Emergency?'),
            ],
          ),
          content: const Text(
            'This will dial 112, India\'s national emergency number.\n\n'
            'Only use this feature in genuine emergencies.\n\n'
            'Are you sure you want to proceed?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Call 112'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      return await callEmergency(context);
    }

    return false;
  }

  static Future<void> sendEmergencySMS({
    required String location,
    required String coordinates,
  }) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: emergencyNumber,
      queryParameters: {
        'body': 'EMERGENCY - SafeYatra User\nLocation: $location\nCoordinates: $coordinates'
      },
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    }
  }

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
