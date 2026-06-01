import 'dart:convert';
import 'package:SafeZone/models/ocorrencia.dart';
import 'package:SafeZone/services/ocorrencia_service.dart';


Future<String> getOcorrenciaMap(double lat, double lng) async {
  final ocorrenciaService = OcorrenciaService();
  
  Stream<List<Ocorrencia>> ocorrenciasDoFirebase = ocorrenciaService.buscarOcorrenciasProximas(raioEmKm: 10, userLat: lat, userLng: lng);

  final ocorrenciasList = await ocorrenciasDoFirebase.first;
  List<Map<String, dynamic>> listaGeoJson = ocorrenciasList.map((ocorrencia) {
    return ocorrencia.toGeoJson();
  }).toList();

  Map<String, dynamic> geoJsonCompleto = {
    "type": "FeatureCollection",
    "features": listaGeoJson,
  };

  return jsonEncode(geoJsonCompleto);
}