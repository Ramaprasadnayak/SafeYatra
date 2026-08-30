import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Safemap extends StatefulWidget {
  const Safemap({super.key});

  @override
  State<Safemap> createState() => _SafemapState();
}

class _SafemapState extends State<Safemap> {
  // Initial location of the map (latitude & longitude)
  static const LatLng _initialPosition = LatLng(12.9716, 77.5946); // Bangalore

  late GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 12,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
      );
  }
}