import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safeyatra/services/profile_pic.dart';

Future<String?> showUpdateProfileSheet(
  BuildContext context, {
  required String currentUrl,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _UpdateProfileSheet(currentUrl: currentUrl),
  );
}

class _UpdateProfileSheet extends StatefulWidget {
  const _UpdateProfileSheet({required this.currentUrl});

  final String currentUrl;

  @override
  State<_UpdateProfileSheet> createState() => _UpdateProfileSheetState();
}

class _UpdateProfileSheetState extends State<_UpdateProfileSheet> {
  final _picker = ImagePicker();
  File? _picked;
  bool _uploading = false;

  void _showError(Object e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
    );
  }

  Future<void> _pick(ImageSource source) async {
    final x = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (x != null) setState(() => _picked = File(x.path));
  }

  Future<void> _upload() async {
    if (_picked == null) return;
    setState(() => _uploading = true);
    try {
      final url = await ProfilePicService.upload(_picked!);
      await ProfilePicService.saveUrl(url);
      if (mounted) Navigator.pop(context, url);
    } catch (e) {
      if (mounted) setState(() => _uploading = false);
      _showError(e);
    }
  }

  Future<void> _reset() async {
    setState(() => _uploading = true);
    try {
      await ProfilePicService.resetToDefault();
      if (mounted) Navigator.pop(context, kDefaultProfilePic);
    } catch (e) {
      if (mounted) setState(() => _uploading = false);
      _showError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Update Profile', style: theme.textTheme.titleLarge),
          const SizedBox(height: 20),
          ClipOval(
            child: SizedBox(
              width: 110,
              height: 110,
              child: _picked != null
                  ? Image.file(_picked!, fit: BoxFit.cover)
                  : Image.network(
                      widget.currentUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.person, size: 60),
                    ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed:
                      _uploading ? null : () => _pick(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_rounded),
                  label: const Text('Gallery'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed:
                      _uploading ? null : () => _pick(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt_rounded),
                  label: const Text('Camera'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: (_picked == null || _uploading) ? null : _upload,
              child: _uploading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Upload'),
            ),
          ),
          TextButton(
            onPressed: _uploading ? null : _reset,
            child: const Text('Reset to default'),
          ),
        ],
      ),
    );
  }
}