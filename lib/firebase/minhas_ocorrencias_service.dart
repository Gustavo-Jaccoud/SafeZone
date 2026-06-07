import 'package:SafeZone/models/ocorrencia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// API de Minhas Ocorrências: busca e exclui as ocorrências do usuário logado
class MinhasOcorrenciasService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Busca todas as ocorrências criadas pelo usuário logado
  Future<List<Ocorrencia>> buscarMinhasOcorrencias() async {
    // Pega o e-mail do logado (mesmo padrão que o PH usou no cadastro)
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email == null) {
      throw Exception('Você precisa estar logado para ver suas ocorrências.');
    }

    try {
      final snapshot = await _firestore
          .collection('ocorrencias')
          .where('criado_por', isEqualTo: email) // filtra pelo e-mail de quem criou
          .orderBy('data') // ordena por data
          .get();

      return snapshot.docs
          .map((doc) => Ocorrencia.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar minhas ocorrências: $e');
    }
  }

  // Exclui uma ocorrência pelo id do documento
  Future<void> excluirOcorrencia(String docId) async {
    try {
      await _firestore.collection('ocorrencias').doc(docId).delete();
    } catch (e) {
      throw Exception('Erro ao excluir ocorrência: $e');
    }
  }
}