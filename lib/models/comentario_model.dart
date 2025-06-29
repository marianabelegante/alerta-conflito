import 'package:cloud_firestore/cloud_firestore.dart';

class ComentarioModel {
  final String texto;
  final DateTime dataHora;

  ComentarioModel({
    required this.texto,
    required this.dataHora,
  });

  // Factory para criar um Comentario a partir de um JSON do Firestore.
  factory ComentarioModel.fromJson(Map<String, dynamic> json) {
    return ComentarioModel(
      texto: json['texto'] ?? 'Comentário inválido',
      // O Firestore retorna um Timestamp, que precisa ser convertido para DateTime.
      dataHora: (json['dataHora'] as Timestamp).toDate(),
    );
  }

  // Método para converter o objeto Comentario para um JSON (para salvar no Firestore).
  Map<String, dynamic> toJson() {
    return {
      'texto': texto,
      // FieldValue.serverTimestamp() para que o servidor do Firebase
      // defina a hora, garantindo consistência.
      'dataHora': FieldValue.serverTimestamp(),
    };
  }
}
