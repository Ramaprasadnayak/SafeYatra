import 'package:google_maps_flutter/google_maps_flutter.dart';

class DistrictPolygonData {
  final String district;
  final String state;
  final String districtCode;
  final String geometryType;
  final List<List<LatLngPoint>> polygons;

  DistrictPolygonData({
    required this.district,
    required this.state,
    required this.districtCode,
    required this.geometryType,
    required this.polygons,
  });

  factory DistrictPolygonData.fromJson(Map<String, dynamic> json) {
    List<List<LatLngPoint>> polygonsList = [];

    if (json['polygons'] != null) {
      for (var polygon in json['polygons'] as List) {
        List<LatLngPoint> points = [];
        for (var point in polygon as List) {
          points.add(
            LatLngPoint(
              lat: (point['lat'] as num).toDouble(),
              lng: (point['lng'] as num).toDouble(),
            ),
          );
        }
        polygonsList.add(points);
      }
    }

    return DistrictPolygonData(
      district: json['district'] as String,
      state: json['state'] as String,
      districtCode: json['district_code'] as String,
      geometryType: json['geometry_type'] as String,
      polygons: polygonsList,
    );
  }
}

class LatLngPoint {
  final double lat;
  final double lng;

  LatLngPoint({required this.lat, required this.lng});

  // Convert to Google Maps LatLng
  LatLng toGoogleLatLng() => LatLng(lat, lng);
}
