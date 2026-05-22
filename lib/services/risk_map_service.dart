import 'dart:ui';

import 'package:SafeZone/mocks/heatmap_mock.dart';
import 'package:SafeZone/theme/app_colors.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class RiskMapService {
  static const sourceId = "risk-source";
  static const layerId = "risk-layer";

  static Future<void> build(MapboxMap map) async {
    final style = map.style;

    // 1. SOURCE (pontos de risco)
    await style.addSource(GeoJsonSource(id: sourceId, data: mockedRiskGeoJson()));
    // 2. HEATMAP (risco orgânico)
    await style.addLayer(
      HeatmapLayer(
        id: layerId,
        sourceId: sourceId,
        heatmapIntensity: 1.0,
        heatmapOpacity: 0.55,
        heatmapWeightExpression: [
          'interpolate',
          ['linear'],
          ['get', 'risk'],

          0, 0,
          5, 0.5,
          10, 1.0,
        ],
        heatmapColorExpression: [
          'interpolate',
          ['linear'],
          ['heatmap-density'],

          0.0, "#78BE4D", // seguro
          0.3, "#F6AE2D", // atenção
          0.7, "#CC3030", // risco
        ],
        heatmapRadiusExpression: [
          'interpolate',
          ['linear'],
          ['zoom'],

          0, 10, // zoom out → menor influência
          10, 20,
          14, 40,
          18, 60, // zoom in → mais detalhe
        ],
        heatmapIntensityExpression: [
          'interpolate',
          ['linear'],
          ['zoom'],

          0, 0.5,
          10, 1.0,
          14, 1.5,
          18, 2.0,
        ],
      ),
    );
  }

}