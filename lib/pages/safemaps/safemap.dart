import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safeyatra/core/constants/map_style.dart';
import 'package:safeyatra/pages/safemaps/notice_menu.dart';
import 'package:safeyatra/services/district_boundary.dart';
import 'package:safeyatra/services/get_prediction.dart';
class Safemap extends StatefulWidget {
  const Safemap({super.key});
  @override
  State<Safemap> createState() => _SafemapState();
}
class _SafemapState extends State<Safemap> {
  double latitude = 0.0;
  double longitude = 0.0;
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
  Future<void> _loadLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLatitude = prefs.getDouble("latitude");
    final savedLongitude = prefs.getDouble("longitude");
    if (savedLatitude != null && savedLongitude != null) {
      latitude = savedLatitude;
      longitude = savedLongitude;
    } else {
      latitude = 20.5937;
      longitude = 78.9629;
    }
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }
  Future<Map<String, dynamic>?> prediction(String userDistrict) async {
    final data = await predict(context, userDistrict);
    if (data == null) {
      if (!mounted) return null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "safety data for this district will be available soon",
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return null;
    }
    final String safetyLabel = data["risk_label"]?.toString() ?? "Unknown";
    final dynamic rawScore = data["safety_score"];
    final double safetyScore = rawScore is num? rawScore.toDouble(): 0.0;
    if (!mounted) return null;
    setState(() {
      status = safetyLabel;
    });
    return {
      "label": safetyLabel,
      "score": safetyScore,
    };
  }
  Color getStatusColor() {
    switch (status?.toLowerCase()) {
      case "high":
        return Colors.red;
      case "moderate":
        return Colors.orange;
      case "low":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
  Future<void> loadBoundary(String districtSearch) async {
    if (districtSearch.trim().isEmpty) return;
    final result = await getDistrictBoundaries(districtSearch.trim(),context);
    if (result == null) return;
    final boundaries =result["boundaries"] as List<List<LatLng>>;
    final matchedName =result["matchedDistrict"] as String;
    final center =result["center"] as Map<String, dynamic>;
    final predictionData = await prediction(matchedName);
    if (predictionData == null) return;
    final String safetyLabel = predictionData["label"] as String;
    final double safetyScore =predictionData["score"] as double;
    final coordinates =center["coordinates"] as List<dynamic>;
    final double centerLongitude =(coordinates[0] as num).toDouble();
    final double centerLatitude =(coordinates[1] as num).toDouble();
    final Color statusColor = getStatusColor();
    final Set<Polygon> polygons = boundaries.asMap().entries.map((entry) {
      return Polygon(
        polygonId: PolygonId("district_${entry.key}"),
        points: entry.value,
        strokeWidth: 2,
        strokeColor: statusColor,
        fillColor: statusColor.withValues(alpha: 0.30),
      );
    }).toSet();
    if (!mounted) return;
    setState(() {
      _polygons = polygons;
      _district = matchedName;
    });
    goToLocation(
      centerLatitude,
      centerLongitude,
    );
    loadDownMenu(
      matchedName,
      safetyScore,
      safetyLabel,
    );
  }
  void goToLocation(double latitude,double longitude) {
    if (!_controllerInitialized) return;
    _controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(latitude, longitude),
        9,
      ),
    );
  }
  bool _controllerInitialized = false;
  
  void loadDownMenu(String district,double safetyScore,String safetyLabel) {
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return NoticeMenu(
          district: district,
          safetyScore: safetyScore,
          safetyLabel: safetyLabel,
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              latitude,
              longitude,
            ),
            zoom: 12,
          ),
          polygons: _polygons,
          style: blueMapStyle,
          onMapCreated: (
            GoogleMapController controller,
          ) {
            _controller = controller;
            _controllerInitialized = true;
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
                stops: const [
                  0.0,
                  0.20,
                  0.40,
                  0.60,
                  0.80,
                  1.0,
                ],
                colors:
                    Theme.of(context).brightness ==
                            Brightness.light
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
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                ),

                hintText: "Search city or district",

                side: const WidgetStatePropertyAll(
                  BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),

                backgroundColor:
                    WidgetStatePropertyAll(
                  Theme.of(context).brightness ==
                          Brightness.light
                      ? Colors.white
                      : Colors.black45,
                ),

                onSubmitted: (value) {
                  loadBoundary(value);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}