import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart'
    hide LocationSettings;

import '../controllers/compass_controller.dart';
import '../controllers/map_controller.dart';
import '../services/location_service.dart';
import '../services/risk_map_service.dart';

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

  final LocationService locationService = LocationService();

  StreamSubscription<geo.Position>? _gpsSubscription;

  /// Coordenada padrão (Aracaju)
  double initialLat = -10.9684319;
  double initialLng = -37.0612574;

  bool carregandoPosicaoInicial = true;
  bool possuiCache = false;

  double? ultimaLatRequisitada;
  double? ultimaLngRequisitada;

  @override
  void initState() {
    super.initState();
    _prepararCoordenadasIniciais();
  }

  @override
  void dispose() {
    _gpsSubscription?.cancel();
    compassController?.dispose();
    super.dispose();
  }

  /// ---------------------------------------------------------
  /// PASSO 1
  /// Lê cache ANTES de renderizar o mapa.
  /// ---------------------------------------------------------
  Future<void> _prepararCoordenadasIniciais() async {
    try {
      final cached = await locationService.getCache();

      if (cached != null) {
        initialLat = cached.lat;
        initialLng = cached.lng;

        possuiCache = true;

        debugPrint("📍 Cache encontrado: $initialLat, $initialLng");
      } else {
        debugPrint("📍 Nenhum cache encontrado. Iniciando em Aracaju.");
      }
    } catch (e) {
      debugPrint("⚠️ Erro lendo cache: $e");
    }

    if (mounted) {
      setState(() {
        carregandoPosicaoInicial = false;
      });
    }
  }

  /// ---------------------------------------------------------
  /// PASSO 2
  /// Inicializa heatmap e GPS.
  /// ---------------------------------------------------------
  Future<void> _inicializarComponentesEGPS(MapboxMap controller) async {
    /// Carrega heatmap imediatamente
    await RiskMapService.build(controller, initialLat, initialLng);

    ultimaLatRequisitada = initialLat;
    ultimaLngRequisitada = initialLng;

    /// Primeira execução (sem cache)
    if (!possuiCache) {
      await _obterPrimeiraLocalizacaoReal(controller);
    }

    /// Indicador azul do usuário
    await controller.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        pulsingEnabled: widget.showUserLocation,
      ),
    );

    _iniciarEscutaGPS(controller);
  }

  /// ---------------------------------------------------------
  /// PASSO 3
  /// Primeira vez na vida do app.
  /// ---------------------------------------------------------
  Future<void> _obterPrimeiraLocalizacaoReal(MapboxMap controller) async {
    try {
      debugPrint("🛰️ Buscando GPS real...");

      final position = await locationService.getCurrentLocation();

      if (position == null) return;

      final lat = position.latitude;
      final lng = position.longitude;

      await locationService.saveCache(lat, lng);

      ultimaLatRequisitada = lat;
      ultimaLngRequisitada = lng;

      /// Heatmap da posição real
      await RiskMapService.build(controller, lat, lng);

      /// Move suavemente a câmera
      await MapControllerService.centerOn(lat, lng);

      debugPrint("✅ Primeira posição salva.");
    } catch (e) {
      debugPrint("⚠️ Erro obtendo GPS inicial: $e");
    }
  }

  /// ---------------------------------------------------------
  /// PASSO 4
  /// GPS em tempo real.
  /// ---------------------------------------------------------
  void _iniciarEscutaGPS(MapboxMap controller) {
    _gpsSubscription =
        geo.Geolocator.getPositionStream(
          locationSettings: const geo.LocationSettings(
            accuracy: geo.LocationAccuracy.high,
            distanceFilter: 15,
          ),
        ).listen((geo.Position position) async {
          if (!mounted) return;

          widget.onLocationChanged?.call(position.latitude, position.longitude);

          if (ultimaLatRequisitada == null || ultimaLngRequisitada == null) {
            ultimaLatRequisitada = position.latitude;
            ultimaLngRequisitada = position.longitude;
            return;
          }

          final distancia = geo.Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            ultimaLatRequisitada!,
            ultimaLngRequisitada!,
          );

          /// Atualiza somente após 500m
          if (distancia >= 500) {
            debugPrint(
              "🔄 Atualizando heatmap (${distancia.toStringAsFixed(0)}m)",
            );

            ultimaLatRequisitada = position.latitude;
            ultimaLngRequisitada = position.longitude;

            await locationService.saveCache(
              position.latitude,
              position.longitude,
            );

            await RiskMapService.build(
              controller,
              position.latitude,
              position.longitude,
            );

            await MapControllerService.centerOn(
              position.latitude,
              position.longitude,
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    if (carregandoPosicaoInicial) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      );
    }

    return MapWidget(
      cameraOptions: CameraOptions(
        center: Point(coordinates: Position(initialLng, initialLat)),
        zoom: widget.zoom,
        pitch: widget.pitch,
        bearing: 0,
      ),
      onMapCreated: (controller) async {
        mapboxMap = controller;

        MapControllerService.setMap(controller);

        await Future.delayed(const Duration(milliseconds: 300));

        await _inicializarComponentesEGPS(controller);

        await controller.scaleBar.updateSettings(
          ScaleBarSettings(
            enabled: true,
            position: OrnamentPosition.TOP_LEFT,
            marginTop: 20,
            marginLeft: 10,
            isMetricUnits: true,
          ),
        );

        compassController = CompassController(controller);

        compassController?.start();
      },
    );
  }
}
