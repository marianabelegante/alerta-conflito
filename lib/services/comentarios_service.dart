import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/comentario_model.dart';

class ComentariosService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Retorna a referência para a sub-coleção de comentários de um evento específico.
  CollectionReference<ComentarioModel> _getComentariosCollection(String eventoId) {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Usuário não autenticado.");
    }
    // A estrutura é /users/{uid}/watchlist/{eventoId}/notes
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('watchlist') // Assumindo que o comentário é de um evento favoritado
        .doc(eventoId)
        .collection('notes')
        .withConverter<ComentarioModel>(
          fromFirestore: (snapshots, _) => ComentarioModel.fromJson(snapshots.data()!),
          toFirestore: (comentario, _) => comentario.toJson(),
        );
  }

  // Adiciona um novo comentário a um evento.
  Future<void> adicionarComentario(String eventoId, String texto) async {
    final comentario = ComentarioModel(
      texto: texto,
      dataHora: DateTime.now(), // A data real será definida pelo servidor.
    );
    await _getComentariosCollection(eventoId).add(comentario);
  }

  // Retorna um Stream com a lista de comentários de um evento, ordenados por data.
  Stream<List<ComentarioModel>> getComentariosStream(String eventoId) {
    return _getComentariosCollection(eventoId)
        .orderBy('dataHora', descending: true) // Mais recentes primeiro.
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
