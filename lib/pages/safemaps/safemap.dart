import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safeyatra/core/constants/map_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Safemap extends StatefulWidget {
  const Safemap({super.key});
  @override
  State<Safemap> createState() => _SafemapState();
}

class _SafemapState extends State<Safemap> {
  double latitude = 12.9716;
  double longitude = 77.5946;
  bool isLoading = true;
  late GoogleMapController _controller;
  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    final prefs = await SharedPreferences.getInstance();
    latitude = prefs.getDouble("latitude") ?? 12.9716;
    longitude = prefs.getDouble("longitude") ?? 77.5946;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 12,
          ),
          // polygons: _buildUdupiPolygons(),
          style: blueMapStyle,
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.20, 0.40, 0.60, 0.80, 1.0],
                colors: const [
                  Color(0xFF060D1E),
                  Color(0xE6060D1E),
                  Color(0xA8060D1E),
                  Color(0x66060D1E),
                  Color(0x22060D1E),
                  Color(0x00060D1E),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: SearchBar(
                shape: const WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                hintText: "Search city or district",
                side: const WidgetStatePropertyAll(
                  BorderSide(color: Colors.blue, width: 2),
                ),
                backgroundColor: const WidgetStatePropertyAll(Color(0xFF0E1827)),
                onSubmitted: (val) => {},
              ),
            ),
          ),
        ),
      ],
    );
  }
}
