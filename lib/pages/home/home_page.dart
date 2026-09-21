import 'package:flutter/material.dart';
import 'package:safeyatra/pages/home/greetings.dart';
import 'package:safeyatra/pages/home/safety_score.dart';
import 'package:safeyatra/pages/home/user_location.dart';

class HomePage extends StatelessWidget {
  final Future<void> Function() onRefreshLocation;
  final String usrname, usrcity, usrstate, usrdistrict, usrnation;
  final double usrscore;

  const HomePage({
    super.key,
    required this.onRefreshLocation,
    required this.usrname,
    required this.usrcity,
    required this.usrdistrict,
    required this.usrstate,
    required this.usrnation,
    required this.usrscore,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Greetings(username: usrname),
            const SizedBox(height: 10),
            UserLocation(
              city: usrcity,
              district: usrdistrict,
              state: usrstate,
              nation: usrnation,
              onChange: () {
                onRefreshLocation();
              },
            ),
            const SizedBox(height: 10),
            SafetyScore(score: usrscore),
          ],
        ),
      ),
    );
  }
}
