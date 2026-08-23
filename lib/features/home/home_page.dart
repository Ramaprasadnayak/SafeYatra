import 'package:flutter/material.dart';
import 'package:safeyatra/features/home/greetings.dart';
import 'package:safeyatra/features/home/safety_score.dart';
import 'package:safeyatra/features/home/user_location.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String usrname="Ramprasad";
  String usrstate="Karnataka";
  String usrcity="Karamangala";
  String usrdistrict="Bengaluru urban";
  double usrscore=78;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          children: [
            SizedBox(height: 10),
            // Greetings
            Greetings(
              username:usrname
            ),
            SizedBox(height: 10),
            // current locations
            UserLocation(
              city:usrcity,
              district:usrdistrict,
              state:usrstate
            ),
            SizedBox(height: 10),
            // ai safety scores
            SafetyScore(
              score:usrscore
            ),
            //
            Card(),
            Row(),
          ],
        ),
      ),
    );
  }
}
