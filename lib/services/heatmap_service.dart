import 'dart:convert';

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../models/heatmap_point.dart';

class HeatmapService {
  static const String sourceId = "heatmap-source";

  static const String layerId = "heatmap-layer";

  static Future<void> renderHeatmap({
    required MapboxMap mapboxMap,
    required List<HeatmapPoint> points,
  }) async {
    final style = mapboxMap.style;

    final geoJson = {
      "type": "FeatureCollection",
      "features": points.map((point) => point.toGeoJsonFeature()).toList(),
    };

    // remove layer antiga
    try {
      await style.removeStyleLayer(layerId);
    } catch (_) {}

    // remove source antiga
    try {
      await style.removeStyleSource(sourceId);
    } catch (_) {}

    // source
    await style.addSource(
      GeoJsonSource(id: sourceId, data: jsonEncode(geoJson)),
    );

    // heatmap layer
    await style.addLayer(
      HeatmapLayer(
        id: layerId,
        sourceId: sourceId,

        heatmapRadius: 30,
        heatmapIntensity: 1.4,
        heatmapOpacity: 0.7,

        heatmapColorExpression: [
          'interpolate',
          ['linear'],
          ['heatmap-density'],

          0.0, 'rgba(120, 190, 77, 0)', // verde transparente
          0.2, '#78BE4D', // verde
          0.4, '#B9D84F', // verde-amarelo
          0.6, '#F6AE2D', // amarelo
          0.8, '#E85D2A', // laranja intermediário
          1.0, '#CC3030', // vermelho
        ],
      ),
    );
  }
}
