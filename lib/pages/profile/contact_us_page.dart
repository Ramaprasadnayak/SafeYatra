import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  static const _supportEmail = 'support@safeyatra.com';
  static const _supportPhone = '+910000000000';

  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _open(Uri uri) async {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the app')),
      );
    }
  }

  Future<void> _sendEmail() async {
    final subject = _subjectCtrl.text.trim();
    final message = _messageCtrl.text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write a message')),
      );
      return;
    }
    final uri = Uri.parse(
      'mailto:$_supportEmail'
      '?subject=${Uri.encodeComponent(subject.isEmpty ? 'SafeYatra Support' : subject)}'
      '&body=${Uri.encodeComponent(message)}',
    );
    await _open(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email_rounded),
                    title: const Text('Email us'),
                    subtitle: const Text(_supportEmail),
                    onTap: () => _open(Uri.parse('mailto:$_supportEmail')),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.call_rounded),
                    title: const Text('Call us'),
                    subtitle: const Text(_supportPhone),
                    onTap: () => _open(Uri.parse('tel:$_supportPhone')),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Send us a message',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _subjectCtrl,
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _messageCtrl,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Message',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: _sendEmail,
                icon: const Icon(Icons.send_rounded),
                label: const Text('Send'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
