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
  final Geocoding geocoding = Geocoding();
  String? usrname = "Dear User";
  String? usrstate = "your state";
  String? usrcity = "your city";
  String? usrdistrict = "your district";
  String? usrnation = "your nation";
  double usrscore = 0;

  Future<void> getLocationDetails() async {
    try {
      Position position = await getCurrentPosition();

      print('Latitude: ${position.latitude}');
      print('Longitude: ${position.longitude}');

      List<Placemark> places = await geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (places.isEmpty) {
        print("No location information found");
        return;
      }
      if(!mounted)return;
      String? district = await getDistrict(
        context,
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      Placemark place = places.first;

      setState(() {
        usrcity = place.locality ?? '';
        usrstate = place.administrativeArea ?? '';
        usrnation = place.country ?? '';
        usrdistrict = district ?? '';
      });

      print('City: $usrcity');
      print('District: $usrdistrict');
      print('State: $usrstate');
      print('Country: $usrnation');
    } catch (e) {
      print('Location error: $e');
    }
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
            UserLocation(
              city: usrcity,
              district: usrdistrict,
              state: usrstate,
              nation: usrnation,
              onChange: getLocationDetails,
            ),
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
