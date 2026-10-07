import 'package:flutter/material.dart';
import 'package:safeyatra/core/utils/email_validator.dart';
import './sos_email_dialog.dart';
import 'package:safeyatra/services/sos_email_service.dart';

class AddSosEmailPage extends StatefulWidget {
  const AddSosEmailPage({super.key});

  @override
  State<AddSosEmailPage> createState() => _AddSosEmailPageState();
}

class _AddSosEmailPageState extends State<AddSosEmailPage> {
  final SosEmailService _emailService = SosEmailService();

  final List<String> _emails = [];

  bool _loading = false;
  bool _loadingEmails = true;

  @override
  void initState() {
    super.initState();
    _loadEmails();
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _loadEmails() async {
    setState(() => _loadingEmails = true);

    try {
      final emails = await _emailService.getEmails();

      if (!mounted) return;

      setState(() {
        _emails
          ..clear()
          ..addAll(emails);
      });
    } on SosEmailException catch (e) {
      if (mounted) {
        _showMessage(e.message);
      }
    } finally {
      if (mounted) {
        setState(() => _loadingEmails = false);
      }
    }
  }

  Future<void> _showAddDialog() async {
    if (_emails.length >= 2) {
      _showMessage('You can add a maximum of 2 SOS emails');
      return;
    }

    final result = await showAddSosEmailDialog(context);

    if (!mounted || result == null) return;

    final email = EmailValidator.normalize(result);

    if (!EmailValidator.isValid(email)) {
      _showMessage('Enter a valid email address');
      return;
    }

    if (_emails.contains(email)) {
      _showMessage('Email already added');
      return;
    }

    if (_emails.length >= 2) {
      _showMessage('You can add a maximum of 2 SOS emails');
      return;
    }

    await _saveEmail(email);
  }

  Future<void> _saveEmail(String email) async {
    if (_loading) return;

    setState(() => _loading = true);

    try {
      await _emailService.addEmail(email);

      if (!mounted) return;

      if (!_emails.contains(email)) {
        setState(() => _emails.add(email));
      }

      _showMessage('Email added successfully');
    } on SosEmailException catch (e) {
      if (mounted) {
        _showMessage(e.message);
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _deleteEmail(String email) async {
    if (_loading) return;

    final confirmed = await showDeleteSosEmailDialog(context, email);

    if (!confirmed || !mounted) return;

    setState(() => _loading = true);

    try {
      await _emailService.deleteEmail(email);

      if (!mounted) return;

      setState(() => _emails.remove(email));
      _showMessage('Email deleted successfully');
    } on SosEmailException catch (e) {
      if (mounted) {
        _showMessage(e.message);
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxEmailsReached = _emails.length >= 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SOS Emails'),
        actions: [
          IconButton(
            onPressed: _loading || _loadingEmails ? null : _loadEmails,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _loading || _loadingEmails || maxEmailsReached
            ? null
            : _showAddDialog,
        icon: _loading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.add),
        label: Text(
          maxEmailsReached
              ? 'Maximum 2 Emails'
              : (_loading ? 'Adding...' : 'Add Email'),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loadingEmails) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_emails.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.email_outlined, size: 60),
              SizedBox(height: 16),
              Text(
                'No SOS email added',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Add up to 2 email addresses '
                'to receive SOS alerts.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _emails.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return _buildEmailCard(_emails[index]);
      },
    );
  }

  Widget _buildEmailCard(String email) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.email_outlined),
        ),
        title: Text(
          email,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          enabled: !_loading,
          onSelected: (value) {
            if (value == 'delete') {
              _deleteEmail(email);
            }
          },
          itemBuilder: (context) {
            return const [
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    SizedBox(width: 10),
                    Text('Delete'),
                  ],
                ),
              ),
            ];
          },
        ),
      ),
    );
  }
}