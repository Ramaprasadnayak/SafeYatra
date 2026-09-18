import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safeyatra/pages/sos/sos_page.dart';
// import 'package:safeyatra/features/auth/login_page.dart';
import 'package:safeyatra/pages/home/home_page.dart';
import 'package:safeyatra/pages/notifications/notification.dart';
import 'package:safeyatra/pages/profile/profile_page.dart';
import 'package:safeyatra/pages/safemaps/safemap.dart';
import 'package:safeyatra/pages/translate/translate_page.dart';
import 'package:geocoding/geocoding.dart';
import 'package:safeyatra/services/get_detail.dart';
import 'package:safeyatra/services/get_prediction.dart';
import 'package:safeyatra/services/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  final Geocoding geocoding = Geocoding();
  String usrname = "Dear Explorer";
  String usrcity = "your city";
  String usrdistrict = "your district";
  String usrstate = "your state";
  String usrnation = "your nation";
  double usrscore = 0;

  @override
  void initState() {
    super.initState();
    _initializeHome();

  }

  Future<void> _initializeHome() async {
    await _loadCachedLocation();
    await getLocationDetails();
    await loaddetails();
    await predictDetails();
  }

  Future<void> predictDetails() async {
    final data = await predict(context, usrdistrict);
    if (data == null || !mounted) return;
    setState(() {
      usrscore = (data["safety_score"] as num).toDouble();
    });

    print("District: ${data["district_name"]}");
    print("State: ${data["state_name"]}");
    print("Risk Score: ${data["safety_score"]}");
    print("Risk Label: ${data["risk_label"]}");
  }

  Future<void> loaddetails() async {
    final info = await getUserInfo(context);
    final prefs = await SharedPreferences.getInstance();
    if (!mounted || info == null) return;
    setState(() {
      usrname = prefs.getString("usrname") ?? info["username"];
    });
    await prefs.setString("usrname", usrname);
  }

  Future<void> _loadCachedLocation() async {
    final saved = await getLocation();
    if (!mounted) return;
    setState(() {
      usrcity = saved[0] ?? usrcity;
      usrdistrict = saved[1] ?? usrdistrict;
      usrstate = saved[2] ?? usrstate;
      usrnation = saved[3] ?? usrnation;
    });
  }

  Future<void> getLocationDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      Position position = await getCurrentPosition();

      List<Placemark> places = await geocoding.placemarkFromCoordinates(
        // position.latitude,
        // position.longitude,
        13.0688,
        74.9936,
      );
      if (places.isEmpty) {
        print("No location information found");
        return;
      }
      await prefs.setDouble("latitude", position.latitude);
      await prefs.setDouble("longitude", position.longitude);
      Placemark place = places.first;

      final currentCity = place.locality ?? "";
      // city that district was last successfully resolved for
      final districtSyncedCity = prefs.getString("districtSyncedCity") ?? "";
      String? district = prefs.getString("district") ?? "your district";

      if (currentCity != districtSyncedCity) {
        if (await isConnected()) {
          if (!mounted) return;
          district = await getDistrict(
            context,
            13.0688,
            74.9936,
            // position.latitude,
            // position.longitude
          );
          if (district != null && district.isNotEmpty) {
            await prefs.setString("districtSyncedCity", currentCity);
          }
        }
      }

      await prefs.setString("city", currentCity);
      await prefs.setString("district", district ?? "");
      await prefs.setString("state", place.administrativeArea ?? "");
      await prefs.setString("nation", place.country ?? "");

      if (!mounted) return;
      setState(() {
        usrcity = currentCity;
        usrstate = place.administrativeArea ?? usrstate;
        usrnation = place.country ?? usrnation;
        usrdistrict = district ?? usrdistrict;
      });
    } catch (e) {
      print('Location error: $e');
    }
  }

  void navigateBottonBar(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(),
      Safemap(),
      SosPage(
        // locality: ,
        // district: ,

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
