import 'package:flutter/material.dart';
import 'package:safeyatra/pages/profile/account_actions.dart';
import 'package:safeyatra/pages/profile/change_password_page.dart';
import 'package:safeyatra/pages/profile/change_phone_page.dart';
import 'package:safeyatra/pages/profile/contact_us_page.dart';
import 'package:safeyatra/pages/profile/theme_sheet.dart';
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
  void _open(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final options = <_ProfileOption>[
      _ProfileOption(Icons.light_mode_rounded, 'Change Theme',
          () => showThemeSheet(context)),
      _ProfileOption(Icons.phone_android_rounded, 'Change Phone Number',
          () => _open(const ChangePhonePage())),
      _ProfileOption(Icons.lock_reset_rounded, 'Change Password',
          () => _open(const ChangePasswordPage())),
      _ProfileOption(Icons.support_agent_rounded, 'Contact Us',
          () => _open(const ContactUsPage())),
      _ProfileOption(Icons.delete_forever_rounded, 'Delete Account',
          () => confirmDeleteAccount(context)),
      _ProfileOption(Icons.logout_rounded, 'Logout',
          () => confirmLogout(context)),
    ];

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey.shade300,
              child: Icon(Icons.person, size: 60, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 35),
            Column(
              children: options
                  .map((o) => MyCard(
                        prefixIcon: o.icon,
                        text: o.title,
                        onPress: o.onTap,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
