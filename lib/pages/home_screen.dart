import 'package:flutter/material.dart';
import 'package:safeyatra/pages/sos/sos_page.dart';
import 'package:safeyatra/pages/home/home_page.dart';
import 'package:safeyatra/pages/notifications/notification.dart';
import 'package:safeyatra/pages/profile/profile_page.dart';
import 'package:safeyatra/pages/safemaps/safemap.dart';
import 'package:safeyatra/pages/translate/translate_page.dart';
import 'package:safeyatra/services/location_service.dart';
import 'package:safeyatra/services/emergency_service.dart' as emergency;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  final Set<int> _visitedTabs = {0};

  final HomeController controller = HomeController();

  @override
  void initState() {
    super.initState();
    controller.initializeHome(context, _refreshUi);
  }

  void _refreshUi() {
    if (mounted) {
      setState(() {});
    }
  }

  void navigateBottomBar(int index) {
    setState(() {
      selectedIndex = index;
      _visitedTabs.add(index);
    });
  }

  Widget _buildPage(int index) {
    if (!_visitedTabs.contains(index)) {
      return const SizedBox.shrink();
    }

    switch (index) {
      case 0:
        return HomePage(
          usrname: controller.usrname,
          usrcity: controller.usrcity,
          usrdistrict: controller.usrdistrict,
          usrstate: controller.usrstate,
          usrnation: controller.usrnation,
          usrscore: controller.usrscore,
          onRefreshLocation: () => controller.refreshLocation(
            context,
            _refreshUi,
          ),
        );
      case 1:
        return Safemap();
      case 2:
        return SosPage(
          locality: controller.usrcity,
          district: controller.usrdistrict,
          coordinates: controller.coordinatesLabel,
          onCallEmergency: () async {
            await emergency.EmergencyService.callEmergencyWithConfirmation(
              context,
            );
          },
        );
      case 3:
        return TranslatePage();
      case 4:
        return ProfilePage();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color logoTextColor =
        Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.shield_outlined,
              color: Colors.blue,
              size: 40,
            ),
            const SizedBox(width: 6),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Safe',
                    style: TextStyle(
                      color: logoTextColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text: 'Yatra',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationPage(),
                ),
              );
            },
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: List.generate(5, _buildPage),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: navigateBottomBar,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          const BottomNavigationBarItem(
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
                  Icon(
                    Icons.call,
                    color: Colors.white,
                    size: 25,
                  ),
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
          const BottomNavigationBarItem(
            icon: Icon(Icons.translate_outlined),
            activeIcon: Icon(Icons.translate),
            label: "Translate",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
