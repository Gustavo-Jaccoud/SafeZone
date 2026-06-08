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
 
  /// Atualiza uma ocorrência já existente, usando o ID do documento do Firestore.
  Future<void> atualizarOcorrencia(Ocorrencia ocorrencia) async {
    final id = ocorrencia.id;
    if (id == null) {
      throw Exception('Não é possível atualizar uma ocorrência sem ID.');
    }
 
    try {
      await _firestore
          .collection('ocorrencias')
          .doc(id)
          .update(ocorrencia.toFirestore());
    } catch (e) {
      throw Exception('Erro ao atualizar ocorrência: $e');
    }
  }
 
 Future<List<Ocorrencia>> buscarOcorrenciasProximas({
    required double userLat,
    required double userLng,
    required double raioEmKm,
  }) async {
    final limites = _calcularLimite(userLat, userLng, raioEmKm);
 
  
    final snapshot = await _firestore
        .collection('ocorrencias')
        .where('latitude', isGreaterThanOrEqualTo: limites['minLat'])
        .where('latitude', isLessThanOrEqualTo: limites['maxLat'])
        .where('longitude', isGreaterThanOrEqualTo: limites['minLng'])
        .where('longitude', isLessThanOrEqualTo: limites['maxLng'])
        .get();
 
    return snapshot.docs
        .map((doc) => Ocorrencia.fromFirestore(doc))
        .toList();
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
