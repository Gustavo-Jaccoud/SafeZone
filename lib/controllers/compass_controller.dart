import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class CompassController {
  StreamSubscription<CompassEvent>? _subscription;

  late final Ticker _ticker;

  final MapboxMap mapboxMap;

  CompassController(this.mapboxMap);

  double targetBearing = 0;
  double currentBearing = 0;

  double? _lastRawHeading;

  static const double threshold = 15.0;

  void start() {
    _configureNativeCompass();
    _startCompassListener();
    _startAnimation();
  }
  void _configureNativeCompass() async {
    await mapboxMap.compass.updateSettings(
      CompassSettings(
        enabled: true,
        position: OrnamentPosition.TOP_RIGHT, 
        marginTop: 20.0, 
        marginRight: 10.0,                     
        fadeWhenFacingNorth: false,      
      ),
    );
  }
  void dispose() {
    _subscription?.cancel();
    _ticker.dispose();
  }

  void _startCompassListener() {
    _subscription = FlutterCompass.events?.listen((event) {
      if (event.heading == null) return;

      final newHeading = event.heading!;

      if (_lastRawHeading == null) {
        _lastRawHeading = newHeading;
        targetBearing = newHeading;
        return;
      }

      final diff = (newHeading - _lastRawHeading!).abs();

      if (diff < threshold) return;

      _lastRawHeading = newHeading;

      targetBearing = newHeading;
    });
  }

  void _startAnimation() {
    _ticker = Ticker((_) {
      double diff = targetBearing - currentBearing;

      diff = normalizeAngle(diff);

      currentBearing += diff * 0.08;

      mapboxMap.setCamera(
        CameraOptions(bearing: currentBearing),
      );
    });

    _ticker.start();
  }

  double normalizeAngle(double angle) {
    return (angle + 540) % 360 - 180;
  }
}