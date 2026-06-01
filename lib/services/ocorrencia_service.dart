import 'package:SafeZone/models/ocorrencia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class OcorrenciaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registrarOcorrencia(Ocorrencia ocorrencia) async {
    try {
      await _firestore
          .collection('ocorrencias')
          .add(ocorrencia.toFirestore());
    } catch (e) {
      throw Exception('Erro ao registrar ocorrência: $e');
    }
  }

  Stream<List<Ocorrencia>> buscarOcorrenciasProximas({
    required double userLat,
    required double userLng,
    required double raioEmKm,
  }) {
    final limites = _calcularLimite(userLat, userLng, raioEmKm);

    return _firestore
        .collection('ocorrencias')
        .where('latitude', isGreaterThanOrEqualTo: limites['minLat'])
        .where('latitude', isLessThanOrEqualTo: limites['maxLat'])
        .where('longitude', isGreaterThanOrEqualTo: limites['minLng'])
        .where('longitude', isLessThanOrEqualTo: limites['maxLng'])
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Ocorrencia.fromFirestore(doc))
          .toList();
    });
  }

  Map<String, double> _calcularLimite(
    double lat,
    double lng,
    double raioEmKm,
  ) {
    const double kmPorGrauLat = 111.32;
    final double deltaLat = raioEmKm / kmPorGrauLat;
    final double cosLat = cos(lat * pi / 180);
    final double deltaLng = raioEmKm / (kmPorGrauLat * cosLat);

    return {
      'minLat': lat - deltaLat,
      'maxLat': lat + deltaLat,
      'minLng': lng - deltaLng,
      'maxLng': lng + deltaLng,
    };
  }
}