import 'package:SafeZone/controllers/map_controller.dart';
import 'package:SafeZone/mocks/heatmap_mock.dart';
import 'package:SafeZone/models/heatmap_point.dart';
import 'package:SafeZone/services/heatmap_service.dart';
import 'package:SafeZone/services/risk_map_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' hide Position;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart'
    hide LocationSettings;

import '../controllers/compass_controller.dart';
import '../services/location_service.dart';

class CustomMapWidget extends StatefulWidget {
  final double zoom;
  final double pitch;
  final bool showUserLocation;

  final Function(double lat, double lng)? onLocationChanged;

  const CustomMapWidget({
    super.key,
    this.zoom = 18,
    this.pitch = 25,
    this.showUserLocation = true,
    this.onLocationChanged,
  });

  @override
  State<CustomMapWidget> createState() => _CustomMapWidgetState();
}

class _CustomMapWidgetState extends State<CustomMapWidget> {
  MapboxMap? mapboxMap;

  CompassController? compassController;

  final locationService = LocationService();

  @override
  void dispose() {
    compassController?.dispose();
    super.dispose();
  }

  Future<void> _setupUserLocation() async {
    if (mapboxMap == null) return;

    await mapboxMap!.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        pulsingEnabled: widget.showUserLocation,
      ),
    );

    // CACHE
    final cached = await locationService.getCache();

    if (cached != null) {
      mapboxMap!.flyTo(
        CameraOptions(
          center: Point(coordinates: cached),
          zoom: widget.zoom,
          pitch: widget.pitch,
        ),
        MapAnimationOptions(duration: 0),
      );
    }

    // GPS REAL
    final position = await locationService.getCurrentLocation();

    if (position == null) return;

    await locationService.saveCache(position.latitude, position.longitude);

    mapboxMap!.flyTo(
      CameraOptions(
        center: Point(
          coordinates: Position(position.longitude, position.latitude),
        ),
        zoom: widget.zoom,
        pitch: widget.pitch,
      ),
      MapAnimationOptions(duration: 1500),
    );

    widget.onLocationChanged?.call(position.latitude, position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return MapWidget(
      cameraOptions: CameraOptions(
        zoom: widget.zoom,
        pitch: widget.pitch,
        bearing: 0,
      ),

      onMapCreated: (controller) async {
        mapboxMap = controller;

        await Future.delayed(const Duration(milliseconds: 300));

        // 🧠 RISK MAP

        await RiskMapService.build(controller);
        await controller.scaleBar.updateSettings(
          ScaleBarSettings(
            enabled: true, 
            position: OrnamentPosition.TOP_LEFT,
            marginTop: 20.0,
            marginLeft: 10.0, 
            isMetricUnits:true, 
          ),
        );

        // Bulsula
        compassController = CompassController(controller);
        compassController?.start();
        MapControllerService.setMap(controller);

        // LOCALIZAÇÃO
        await _setupUserLocation();
      },
    );
  }
}
