import 'package:shared_preferences/shared_preferences.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class LocationCache {
  static Future<void> save(double lat, double lng) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble('lat', lat);
    await prefs.setDouble('lng', lng);
  }

  static Future<Position?> get() async {
    final prefs = await SharedPreferences.getInstance();

    final lat = prefs.getDouble('lat');
    final lng = prefs.getDouble('lng');

    if (lat == null || lng == null) return null;

    return Position(lng, lat);
  }
}