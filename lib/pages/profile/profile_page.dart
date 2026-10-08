import 'package:flutter/material.dart';
import 'package:safeyatra/pages/profile/account_actions.dart';
import 'package:safeyatra/pages/profile/change_password_page.dart';
import 'package:safeyatra/pages/profile/add_sos_email.dart';
import 'package:safeyatra/pages/profile/contact_us_page.dart';
import 'package:safeyatra/pages/profile/theme_sheet.dart';
import 'package:safeyatra/services/profile_pic.dart';
import 'package:safeyatra/widgets/profile_card.dart';

class _ProfileOption {
  const _ProfileOption(this.icon, this.title, this.onTap);

  final IconData icon;
  final String title;
  final VoidCallback onTap;
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _profileUrl;

  @override
  void initState() {
    super.initState();
    ProfilePicService.getSavedUrl().then((url) {
      if (mounted) setState(() => _profileUrl = url);
    });
  }

  Future<void> _updateProfile() async {
    final newUrl = await showUpdateProfileSheet(
      context,
      currentUrl: _profileUrl ?? kDefaultProfilePic,
    );
    if (newUrl != null && mounted) setState(() => _profileUrl = newUrl);
  }

  void _open(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final options = <_ProfileOption>[
      _ProfileOption(
        Icons.light_mode_rounded,
        'Change Theme',
        () => showThemeSheet(context),
      ),
      _ProfileOption(
        Icons.phone_android_rounded,
        'Add SOS Email',
        () => _open(const AddSosEmailPage()),
      ),
      _ProfileOption(
        Icons.lock_reset_rounded,
        'Change Password',
        () => _open(const ChangePasswordPage()),
      ),
      _ProfileOption(
        Icons.support_agent_rounded,
        'Contact Us',
        () => _open(const ContactUsPage()),
      ),
      _ProfileOption(
        Icons.delete_forever_rounded,
        'Delete Account',
        () => confirmDeleteAccount(context),
      ),
      _ProfileOption(
        Icons.logout_rounded,
        'Logout',
        () => confirmLogout(context),
      ),
    ];
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            ClipOval(
              child: SizedBox(
                width: 110,
                height: 110,
                child: _profileUrl == null
                    ? const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Image.network(
                        _profileUrl!,
                        key: ValueKey(_profileUrl),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.person, size: 60),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _updateProfile,
              icon: const Icon(Icons.edit_rounded, size: 18),
              label: const Text('Update Profile'),
            ),
            const SizedBox(height: 23),
            Column(
              children: options
                  .map(
                    (o) => MyCard(
                      prefixIcon: o.icon,
                      text: o.title,
                      onPress: o.onTap,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
