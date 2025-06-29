import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../models/evento_model.dart';

class ApiAcledService {
  final String _baseUrl = 'api.acleddata.com';
  final String _apiPath = '/acled/read';
  final String _apiKey = 'S!tkgNsLYdj*TCM-!bIg';
  final String _apiEmail = 'm.belegante@estudante.ifro.edu.br';

  Future<List<Evento>> buscarEventosPorPais(String pais) async {
    final url = Uri.https(_baseUrl, _apiPath, {
      'key': _apiKey,
      'email': _apiEmail,
      'country': pais,
      'terms': 'accepted',
    });
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = json.decode(response.body);
        if (decodedData['success'] == true && decodedData['data'] != null) {
          final List<dynamic> eventosData = decodedData['data'];
          final List<Evento> listaEventos = eventosData
              .where((item) => item['event_date'] != null && item['event_type'] != null && item['location'] != null)
              .map((json) => Evento.fromJson(json))
              .toList();

          // Salva a lista de eventos no Hive após o carregamento bem-sucedido.
          final box = Hive.box('eventosBox');
          // Converte a lista de objetos Evento de volta para uma lista de Maps para salvar.
          box.put('eventos', listaEventos.map((e) => e.toJson()).toList());
          
          return listaEventos;
        } else {
          throw(decodedData['error'] ?? 'A API não retornou dados.');
        }
      } else {
        throw('Falha na conexão: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
