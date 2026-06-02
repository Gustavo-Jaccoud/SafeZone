import 'dart:convert';
import 'package:SafeZone/models/ocorrencia.dart';
import 'package:SafeZone/firebase/ocorrencia_service.dart';

class HeatmapService {
  final _ocorrenciaService = OcorrenciaService();

  Future<String> getOcorrenciaMap(double lat, double lng) async {
    // Busca os dados uma única vez através do Future
    final ocorrenciasList = await _ocorrenciaService.buscarOcorrenciasProximas(
      userLat: lat,
      userLng: lng,
      raioEmKm: 10,
    );
    print(ocorrenciasList);
    final listaGeoJson = ocorrenciasList.map((Ocorrencia ocorrencia) {
      return ocorrencia.toGeoJson();
    }).toList();

    final geoJsonCompleto = {
      'type': 'FeatureCollection',
      'features': listaGeoJson,
    };

    return jsonEncode(geoJsonCompleto);
  }
}