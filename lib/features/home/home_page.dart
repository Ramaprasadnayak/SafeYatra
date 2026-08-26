import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safeyatra/features/home/greetings.dart';
import 'package:safeyatra/features/home/safety_score.dart';
import 'package:safeyatra/features/home/user_location.dart';
import 'package:geocoding/geocoding.dart';
import 'package:safeyatra/services/location.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? usrname = "Ramprasad";
  String? usrstate = "";
  String? usrcity = "";
  String? usrdistrict = "";
  String? usrnation = "";
  double usrscore = 0;
  
  Future<void> getLocationDetails() async {
    Position position = await getCurrentPosition();
    List<Placemark> places = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (places.isEmpty) {
      print("No location information found");
      return;
    }
    Placemark place = places.first;
    setState(() {
      usrcity= place.locality;
      usrdistrict = place.subAdministrativeArea;
      usrstate=place.administrativeArea;
      usrnation=place.country;
    });
    print("City: ${place.locality}");
    print("District: ${place.subAdministrativeArea}");
    print("State: ${place.administrativeArea}");
    print("Country: ${place.country}");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          children: [
            SizedBox(height: 10),
            // Greetings
            Greetings(username: usrname),
            SizedBox(height: 10),
            // current locations
            UserLocation(city: usrcity, district: usrdistrict, state: usrstate, nation: usrnation),
            SizedBox(height: 10),
            // ai safety scores
            SafetyScore(score: usrscore),
            //
            Card(),
            Row(),
          ],
        ),
      ),
    );
  }
}
