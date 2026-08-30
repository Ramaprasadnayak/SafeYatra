import 'package:flutter/material.dart';
// import 'package:maruthimedical/services/get_detail.dart';
import 'package:safeyatra/widgets/profile_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "";
  @override
  void initState() {
    super.initState();
    getUsername();
  }

  Future<void> getUsername() async {
    // final name = await loadTokenSub();
    String name="ram";

    if (name != null) {
      setState(() {
        username = name.length > 15 ? "${name.substring(0, 15)}..." : name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final VoidCallback? changeTheme=null;
    final VoidCallback? changePhoneno=null;
    final VoidCallback? changePassword=null;
    final VoidCallback? contact=null;
    final VoidCallback? deleteAcc=null;
    final VoidCallback? logout=null;

    Map<int, List<Object?>> profileOptions = {
      1: [Icons.light_mode_rounded, "Change Theme", true, changeTheme],
      2: [Icons.phone_android_rounded, "Change Phone Number", false, changePhoneno],
      3: [Icons.lock_reset_rounded, "Change Password", false, changePassword],
      4: [Icons.support_agent_rounded, "Contact Us", false, contact],
      5: [Icons.delete_forever_rounded, "Delete Account", false, deleteAcc],
      6: [Icons.logout_rounded, "Logout", false, logout],
    };
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            // Column(children: [Text("hello, $username")]),
            // SizedBox(height: 20),
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey.shade300,
              child: Icon(Icons.person, size: 60, color: Colors.grey.shade700),
            ),
            SizedBox(height: 15),
            // OutlinedButton(
            //   onPressed: () {
            //     showModalBottomSheet(
            //       context: context, 
            //       builder: (context){
            //         return ProfilePic();
            //       },
            //     );
            //   }, 
            //   child: const Text("Edit Profile")
            // ),
            SizedBox(height: 20),
            Column(
              children: profileOptions.entries.map((entry) {
                return MyCard(
                  prefixIcon: entry.value[0] as IconData,
                  text: entry.value[1] as String,
                  addButton: entry.value[2] as bool,
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