import 'package:flutter/material.dart';
import 'package:safeyatra/pages/sos/sos_page.dart';
import 'package:safeyatra/pages/home/home_page.dart';
import 'package:safeyatra/pages/notifications/notification.dart';
import 'package:safeyatra/pages/profile/profile_page.dart';
import 'package:safeyatra/pages/safemaps/safemap.dart';
import 'package:safeyatra/pages/translate/translate_page.dart';
import 'package:safeyatra/services/location_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  String username = "";
  final HomeController controller = HomeController();
  @override
  void initState() {
    super.initState();
    controller.initializeHome(
      context,
      () {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  void navigateBottonBar(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(
        usrname:controller.usrname,
        usrcity:controller.usrcity,
        usrdistrict:controller.usrdistrict,
        usrstate:controller.usrstate,
        usrnation:controller.usrnation,
        usrscore: controller.usrscore,
        getLocationDetails:controller.getLocationDetails,
      ),
      Safemap(),
      SosPage(
        locality: controller.usrcity,
        district: controller.usrdistrict,
        coordinates: "${controller.latitude}° N, ${controller.longitude}° E",
        onCallEmergency: () {
          // e.g. url_launcher: launchUrl(Uri.parse("tel:112"));
        },
      ),
      TranslatePage(),
      ProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/logo/icon.png", height: 120),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
            icon: Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: IndexedStack(index: selectedIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: navigateBottonBar,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: "Safety Map",
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 65,
              height: 65,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.call, color: Colors.white, size: 25),
                  Text(
                    "SOS",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.translate_outlined),
            activeIcon: Icon(Icons.translate),
            label: "Translate",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
