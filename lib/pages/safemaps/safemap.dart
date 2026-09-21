import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safeyatra/core/constants/map_style.dart';
import 'package:safeyatra/pages/safemaps/notice_menu.dart';
import 'package:safeyatra/services/district_boundary.dart';
import 'package:safeyatra/services/get_prediction.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Safemap extends StatefulWidget {
  const Safemap({super.key});
  @override
  State<Safemap> createState() => _SafemapState();
}

class _SafemapState extends State<Safemap> {
  double latitude = 0.0;
  double longitude = 0.0;
  Color mycolor= Colors.blue.withValues(alpha: 0.25);
  String? status;
  bool isLoading = true;
  late GoogleMapController _controller;
  Set<Polygon> _polygons = {};
  String _district = "";

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }
  Future<void> prediction(String usrdistrict) async {
    final data = await predict(context, usrdistrict);
    if (data == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No safety data available for this district"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    setState(() {
      status = data["risk_label"] as String;
    });
  }
  Future<void> _loadLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLatitude = prefs.getDouble("latitude");
    final savedLongitude = prefs.getDouble("longitude");

    if (savedLatitude != null && savedLongitude != null) {
      latitude = savedLatitude;
      longitude = savedLongitude;
    } else {
      // Use India's center as fallback when no location is cached
      latitude = 20.5937;
      longitude = 78.9629;
    }

    setState(() {
      isLoading = false;
    });
  }

  void goToLocation(double latitude, double longitude) {
    _controller.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(latitude, longitude), 8),
    );
  }

  void loadBoundary(String distcode) async {
    final statusColor = getStatusColor();
    final result = await getDistrictBoundaries(distcode, context);
    if (result != null) {
      final boundaries = result["boundaries"] as List<List<LatLng>>;
      final matchedName = result["matchedDistrict"] as String;
      final center = result["center"] as Map<String, dynamic>;
      prediction(matchedName);
      final coordinates = center["coordinates"] as List<dynamic>;
      final double longitude = (coordinates[0] as num).toDouble();
      final double latitude = (coordinates[1] as num).toDouble();
      final Set<Polygon> polygons = boundaries.asMap().entries.map((entry) {
        return Polygon(
          polygonId: PolygonId("district_${entry.key}"),
          points: entry.value,
          strokeWidth: 2,
          fillColor: statusColor,
        );
      }).toSet();
      setState(() {
        _polygons = polygons;
        _district = matchedName;
      });
      goToLocation(latitude, longitude);
      loadDownMenu(_district);
    }
  }
  Color getStatusColor() {
    if (status == "High") {
      return Colors.red;
    } else if (status == "Moderate") {
      return Colors.orange;
    } else if (status == "Low"){
      return Colors.green;
    }
    else{
      return Colors.grey;
    }
  }

  void loadDownMenu(String district) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return NoticeMenu(district: district);
      },
    );
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
          polygons: _polygons,
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
                colors: Theme.of(context).brightness == Brightness.light
                    ? const [
                        Color(0xFFFFFFFF),
                        Color(0xE6FFFFFF),
                        Color(0xA8FFFFFF),
                        Color(0x66FFFFFF),
                        Color(0x22FFFFFF),
                        Color(0x00FFFFFF),
                      ]
                    : const [
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
                backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Colors.black45,
                ),
                onSubmitted: (val) => loadBoundary(val),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
