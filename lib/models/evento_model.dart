import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'comentario_model.dart';

class Evento {
  final String id;
  final String pais;
  final String data;
  final String tipo;
  final int fatalidades;
  final String localizacao;
  final String descricao;
  final String fonte;
  final String latitude;
  final String longitude;
  // Cada evento agora carrega sua própria lista de comentários.
  final RxList<ComentarioModel> comentarios;

  Evento({
    required this.id,
    required this.pais,
    required this.data,
    required this.tipo,
    required this.fatalidades,
    required this.localizacao,
    required this.descricao,
    required this.fonte,
    required this.latitude,
    required this.longitude,
    List<ComentarioModel>? comentarios, // Torna a lista opcional no construtor
  }) : comentarios = (comentarios ?? <ComentarioModel>[]).obs; // Inicializa a lista

  factory Evento.fromJson(Map<String, dynamic> json) {
    final uniqueString = (json['event_date'] ?? '') +
                         (json['event_type'] ?? '') +
                         (json['location'] ?? '') +
                         (json['notes'] ?? '');

    final id = sha1.convert(utf8.encode(uniqueString)).toString();

    return Evento(
      id: json['id']?.toString() ?? id,
      pais: json['country'] ?? json['pais'] ?? 'Não informado',
      data: json['event_date'] ?? json['data'] ?? 'Não informado',
      tipo: json['event_type'] ?? json['tipo'] ?? 'Não informado',
      fatalidades: json['fatalities'] is int ? json['fatalities'] : int.tryParse(json['fatalities'] ?? '0') ?? 0,
      localizacao: json['location'] ?? json['localizacao'] ?? 'Não informado',
      descricao: json['notes'] ?? json['descricao'] ?? 'Nenhuma descrição fornecida.',
      fonte: json['source'] ?? json['fonte'] ?? 'Não informado',
      latitude: json['latitude']?.toString() ?? 'N/A',
      longitude: json['longitude']?.toString() ?? 'N/A',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pais': pais,
      'data': data,
      'tipo': tipo,
      'fatalidades': fatalidades,
      'localizacao': localizacao,
      'descricao': descricao,
      'fonte': fonte,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
