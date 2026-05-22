import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapControllerService {
  static MapboxMap? _map;

  static void setMap(MapboxMap map) {
    _map = map;
  }

  static MapboxMap? get map => _map;

  static Future<void> centerOn(double lat, double lng) async {
    if (_map == null) return;

    await _map!.flyTo(
      CameraOptions(
        center: Point(
          coordinates: Position(lng, lat),
        ),
        zoom: 18,
      ),
      MapAnimationOptions(duration: 1200),
    );
  }
}