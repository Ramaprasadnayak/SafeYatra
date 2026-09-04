import 'package:flutter/material.dart';
import 'package:safeyatra/widgets/profile_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final VoidCallback? changeTheme=null;
    final VoidCallback? changePhoneno=null;
    final VoidCallback? changePassword=null;
    final VoidCallback? contact=null;
    final VoidCallback? deleteAcc=null;
    final VoidCallback? logout=null;

    Map<int, List<Object?>> profileOptions = {
      1: [Icons.light_mode_rounded, "Change Theme", changeTheme],
      2: [Icons.phone_android_rounded, "Change Phone Number", changePhoneno],
      3: [Icons.lock_reset_rounded, "Change Password", changePassword],
      4: [Icons.support_agent_rounded, "Contact Us", contact],
      5: [Icons.delete_forever_rounded, "Delete Account", deleteAcc],
      6: [Icons.logout_rounded, "Logout", logout],
    };
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey.shade300,
              child: Icon(Icons.person, size: 60, color: Colors.grey.shade700),
            ),
            SizedBox(height: 15),
            SizedBox(height: 20),
            Column(
              children: profileOptions.entries.map((entry) {
                return MyCard(
                  prefixIcon: entry.value[0] as IconData,
                  text: entry.value[1] as String,
                  onPress: entry.value[3] as VoidCallback?,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}