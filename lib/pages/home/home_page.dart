import 'package:flutter/material.dart';
import 'package:safeyatra/pages/home/greetings.dart';
import 'package:safeyatra/pages/home/safety_score.dart';
import 'package:safeyatra/pages/home/user_location.dart';
// import 'package:safeyatra/services/location_service.dart';

class HomePage extends StatefulWidget {
  final Future<void> Function(BuildContext,VoidCallback) getLocationDetails;
  final String usrname,usrcity,usrstate,usrdistrict,usrnation;
  final double usrscore;
  const HomePage({
    super.key,
    required this.getLocationDetails,
    required this.usrname,
    required this.usrcity,
    required this.usrdistrict,
    required this.usrstate,
    required this.usrnation,
    required this.usrscore
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Greetings(username: widget.usrname),
            const SizedBox(height: 10),
            UserLocation(
              city: widget.usrcity,
              district: widget.usrdistrict,
              state: widget.usrstate,
              nation: widget.usrnation,
              onChange: () {
                widget.getLocationDetails(
                  context,
                  () {
                    if (mounted) {
                      setState(() {});
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 10),
            SafetyScore(
              score: widget.usrscore,
            ),
          ],
        ),
      ),
    );
  }
}