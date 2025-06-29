import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/evento_model.dart';

class WatchlistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Retorna a referência para a coleção de watchlist do usuário logado.
  CollectionReference<Evento> get _watchlistCollection {
    final user = _auth.currentUser;
    if (user == null) {
      // Lança uma exceção se não houver um usuário logado.
      throw Exception("Usuário não autenticado para acessar a watchlist.");
    }
    // Usa um conversor para que o Firestore trabalhe diretamente com objetos Evento.
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('watchlist')
        .withConverter<Evento>(
          fromFirestore: (snapshots, _) => Evento.fromJson(snapshots.data()!),
          toFirestore: (evento, _) => evento.toJson(),
        );
  }

  // Adiciona um evento à watchlist no Firestore.
  Future<void> adicionarEvento(Evento evento) async {
    // Usa o ID único do evento como ID do documento para evitar duplicatas.
    await _watchlistCollection.doc(evento.id).set(evento);
  }

  // Remove um evento da watchlist no Firestore.
  Future<void> removerEvento(String eventoId) async {
    await _watchlistCollection.doc(eventoId).delete();
  }

  // Retorna um Stream com a lista de eventos da watchlist.
  Stream<List<Evento>> getWatchlist() {
    return _watchlistCollection
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // Retorna um Stream com os IDs dos eventos na watchlist.
  Stream<Set<String>> getWatchlistIds() {
    return _watchlistCollection
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toSet());
  }
}
