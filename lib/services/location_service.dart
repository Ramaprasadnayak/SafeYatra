import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safeyatra/services/get_detail.dart';
import 'package:safeyatra/services/get_prediction.dart';
import 'package:safeyatra/services/location.dart';

class HomeController {
  final Geocoding geocoding = Geocoding();
  static const String _defaultName = "Dear Explorer";
  static const String _defaultCity = "your city";
  static const String _defaultDistrict = "your district";
  static const String _defaultState = "your state";
  static const String _defaultNation = "your nation";
  static const double _minMoveMeters = 2000;
  String usrname = _defaultName;
  String usrcity = _defaultCity;
  String usrdistrict = _defaultDistrict;
  String usrstate = _defaultState;
  String usrnation = _defaultNation;
  double usrscore = 0;
  double latitude = 0.0;
  double longitude = 0.0;
  double? _geocodedLat;
  double? _geocodedLng;
  bool _locating = false;

  bool get hasFix => latitude != 0.0 || longitude != 0.0;

  bool get hasDistrict =>
      usrdistrict.isNotEmpty && usrdistrict != _defaultDistrict;
   String get coordinatesLabel {
    if (!hasFix) return "Locating...";
    final ns = latitude >= 0 ? "N" : "S";
    final ew = longitude >= 0 ? "E" : "W";
    return "${latitude.abs().toStringAsFixed(4)}° $ns, "
        "${longitude.abs().toStringAsFixed(4)}° $ew";
  }

  String? _nonEmpty(String? value) =>
      (value == null || value.isEmpty) ? null : value;
  Future<void> _safely(Future<void> Function() task) async {
    try {
      await task();
    } catch (_) {
    }
  }
  Future<void> initializeHome(
    BuildContext context,
    VoidCallback onUpdate,
  ) async {
    await loadCachedData(onUpdate);
    if (!context.mounted) return;

    final districtBefore = usrdistrict;
    await Future.wait([
      _safely(() => getLocationDetails(context, onUpdate)),
      _safely(() => loadDetails(context, onUpdate)),
      if (hasDistrict) _safely(() => predictDetails(context, onUpdate)),
    ]);
    if (context.mounted && hasDistrict && usrdistrict != districtBefore) {
      await _safely(() => predictDetails(context, onUpdate));
    }
  }

  Future<void> loadCachedData(VoidCallback onUpdate) async {
    final prefs = await SharedPreferences.getInstance();

    usrname = _nonEmpty(prefs.getString("usrname")) ?? usrname;
    usrcity = _nonEmpty(prefs.getString("city")) ?? usrcity;
    usrdistrict = _nonEmpty(prefs.getString("district")) ?? usrdistrict;
    usrstate = _nonEmpty(prefs.getString("state")) ?? usrstate;
    usrnation = _nonEmpty(prefs.getString("nation")) ?? usrnation;
    usrscore = prefs.getDouble("safety_score") ?? usrscore;
    latitude = prefs.getDouble("latitude") ?? latitude;
    longitude = prefs.getDouble("longitude") ?? longitude;

    if (hasFix && usrcity != _defaultCity) {
      _geocodedLat = latitude;
      _geocodedLng = longitude;
    }

    onUpdate();
  }
  Future<void> predictDetails(
    BuildContext context,
    VoidCallback onUpdate,
  ) async {
    if (!hasDistrict) return;

    final requestedDistrict = usrdistrict;

    try {
      final data = await predict(context, requestedDistrict)
          .timeout(const Duration(seconds: 15));
      if (data == null) return;
      if (requestedDistrict != usrdistrict) return;

      final prefs = await SharedPreferences.getInstance();

      final label = data["risk_label"];
      if (label is String) {
        await prefs.setString("safety_label", label);
      }

      final score = data["safety_score"];
      if (score is num) {
        usrscore = score.toDouble();
        await prefs.setDouble("safety_score", usrscore);
        onUpdate();
      }
    } catch (_) {
    }
  }
  Future<void> loadDetails(BuildContext context, VoidCallback onUpdate) async {
    final prefs = await SharedPreferences.getInstance();

    final cached = _nonEmpty(prefs.getString("usrname"));
    if (cached != null) {
      usrname = cached;
      onUpdate();
      return;
    }

    if (!context.mounted) return;
    final info = await getUserInfo(context);

    final name = info?["username"];
    if (name is! String || name.isEmpty) return;

    usrname = name;
    await prefs.setString("usrname", name);
    onUpdate();
  }
  Future<void> refreshLocation(
    BuildContext context,
    VoidCallback onUpdate,
  ) async {
    final districtBefore = usrdistrict;

    await getLocationDetails(context, onUpdate, force: true);

    if (context.mounted && hasDistrict && usrdistrict != districtBefore) {
      await predictDetails(context, onUpdate);
    }
  }

  Future<void> getLocationDetails(
    BuildContext context,
    VoidCallback onUpdate, {
    bool force = false,
  }) async {
    if (_locating) return;
    _locating = true;

    try {
      if (!force) {
        final quick = await _lastKnownPosition();
        if (quick != null) {
          await _applyPosition(context, quick, onUpdate, force: false);
        }
        if (!context.mounted) return;
      }
      final fresh = await _freshPosition() ??
          (force ? await _lastKnownPosition() : null);

      if (fresh != null && context.mounted) {
        await _applyPosition(context, fresh, onUpdate, force: force);
      }
    } catch (_) {
    } finally {
      _locating = false;
    }
  }

  Future<Position?> _lastKnownPosition() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } catch (_) {
      return null;
    }
  }

  Future<Position?> _freshPosition() async {
    try {
      return await getCurrentPosition().timeout(const Duration(seconds: 12));
    } catch (_) {
      return null;
    }
  }

  Future<void> _applyPosition(
    BuildContext context,
    Position position,
    VoidCallback onUpdate, {
    required bool force,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final lat = position.latitude;
    final lng = position.longitude;
    latitude = lat;
    longitude = lng;
    await prefs.setDouble("latitude", lat);
    await prefs.setDouble("longitude", lng);
    onUpdate();
    final refLat = _geocodedLat;
    final refLng = _geocodedLng;
    if (!force &&
        hasDistrict &&
        refLat != null &&
        refLng != null &&
        Geolocator.distanceBetween(refLat, refLng, lat, lng) <
            _minMoveMeters) {
      return;
    }

    if (!context.mounted) return;

    final List<Placemark> places;
    try {
      places = await geocoding
          .placemarkFromCoordinates(lat, lng)
          .timeout(const Duration(seconds: 8));
    } catch (_) {
      return;
    }
    if (places.isEmpty) return;

    final place = places.first;
    final city = _nonEmpty(place.locality);
    final state = _nonEmpty(place.administrativeArea);
    final nation = _nonEmpty(place.country);
    if (city != null) {
      usrcity = city;
      await prefs.setString("city", city);
    }
    if (state != null) {
      usrstate = state;
      await prefs.setString("state", state);
    }
    if (nation != null) {
      usrnation = nation;
      await prefs.setString("nation", nation);
    }

    _geocodedLat = lat;
    _geocodedLng = lng;
    onUpdate();
    var district = _nonEmpty(prefs.getString("district"));
    final syncedCity = prefs.getString("districtSyncedCity") ?? "";
    final needsDistrict =
        district == null || (city != null && city != syncedCity);

    if (needsDistrict && await isConnected() && context.mounted) {
      try {
        final fetched = await getDistrict(context, lat, lng)
            .timeout(const Duration(seconds: 10));

        if (fetched != null && fetched.isNotEmpty) {
          district = fetched;
          await prefs.setString("district", fetched);
          if (city != null) {
            await prefs.setString("districtSyncedCity", city);
          }
        }
      } catch (_) {
      }
    }

    if (district != null) {
      usrdistrict = district;
    }
    onUpdate();
  }
}
