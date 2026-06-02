import 'package:SafeZone/firebase/heatmap_service.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class RiskMapService {
  static const sourceId = "risk-source";
  static const layerId = "risk-layer";

  static Future<void> build(MapboxMap map, double latitude, double longitude) async {
    final style = map.style;
    final heatmapService = HeatmapService();

    // Se já existir a camada, removemos para evitar duplicidade ao recarregar
    if (await style.styleSourceExists(sourceId)) return;

    // 1. Busca os pontos e injeta na Source
    final geojson = await heatmapService.getOcorrenciaMap(latitude, longitude);
    await style.addSource(GeoJsonSource(id: sourceId, data: geojson));

    // 2. Cria a camada visual do Heatmap
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
          0.0, "#78BE4D", // Seguro (Mapa começa verde)
          0.3, "#F6AE2D", // Atenção
          0.7, "#CC3030", // Risco
        ],
        heatmapRadiusExpression: [
          'interpolate',
          ['linear'],
          ['zoom'],
          0, 10,
          10, 20,
          14, 40,
          18, 60,
        ],
      ),
    );
  }
}