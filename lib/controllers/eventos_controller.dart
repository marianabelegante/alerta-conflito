import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/evento_model.dart';
import '../services/api_acled_service.dart';
import '../services/autenticacao_service.dart';
import '../services/watchlist_service.dart';

extension StringExtension on String {
  String capitalizeWords() {
    if (trim().isEmpty) return "";
    return split(' ').map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}' : '').join(' ');
  }
}

class EventosController extends GetxController {
  final ApiAcledService _apiService = ApiAcledService();
  final AutenticacaoService _autenticacaoService = AutenticacaoService();
  // Encontra a instância real do WatchlistService que agora usa Firestore.
  final WatchlistService _watchlistService = Get.find<WatchlistService>();

  final paisController = TextEditingController();
  final paisFocusNode = FocusNode();

  var eventos = <Evento>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var watchlistIds = <String>{}.obs;

  final Map<String, String> _paisesTraduzidos = {
    'brasil': 'Brazil',
    'estados unidos': 'United States',
    'eua': 'United States',
    'canadá': 'Canada',
    'ucrânia': 'Ukraine',
    'afeganistão': 'Afghanistan',
    'síria': 'Syria',
    'reino unido': 'United Kingdom'
  };

  @override
  void onInit() {
    super.onInit();
    // Inicia a escuta do stream de IDs de favoritos do Firestore.
    watchlistIds.bindStream(_watchlistService.getWatchlistIds());
    buscarEventos(pais: 'Brazil', nomeExibicao: 'Brasil');
  }

  void buscarEventosPorFiltro() {
    final paisDigitado = paisController.text.trim();
    if (paisDigitado.isEmpty) {
      errorMessage.value = 'Por favor, digite um país para buscar.';
      return;
    }
    final paisEmIngles = _paisesTraduzidos[paisDigitado.toLowerCase()] ?? paisDigitado.capitalizeWords();
    paisFocusNode.unfocus();
    buscarEventos(pais: paisEmIngles, nomeExibicao: paisDigitado);
  }

  Future<void> buscarEventos({required String pais, String? nomeExibicao}) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final resultado = await _apiService.buscarEventosPorPais(pais);
      eventos.clear();
      final eventosValidos = resultado.where((evento) => evento.id.isNotEmpty).toList();
      if (eventosValidos.isEmpty) {
        errorMessage.value = 'Nenhum evento válido encontrado para "${nomeExibicao ?? pais}".';
      } else {
        eventos.assignAll(eventosValidos);
        Get.snackbar('Sucesso', 'Eventos carregados da internet.', snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2));
      }
    } catch (e) {
      errorMessage.value = 'Falha ao buscar da internet. Carregando dados do cache...';
      final box = Hive.box('eventosBox');
      final eventosSalvos = List<Map<String, dynamic>>.from(box.get('eventos', defaultValue: []));
      
      if (eventosSalvos.isEmpty) {
        errorMessage.value = 'Falha na conexão e não há dados em cache.';
        eventos.clear();
      } else {
        eventos.assignAll(eventosSalvos.map((e) => Evento.fromJson(e)).toList());
        errorMessage.value = ''; 
        Get.snackbar('Modo Offline', 'Mostrando os últimos dados salvos.', snackPosition: SnackPosition.BOTTOM);
      }
    } finally {
      isLoading.value = false;
    }
  }
  
  void toogleWatchlist(Evento evento) async {
    if (evento.id.isEmpty) {
      Get.snackbar('Erro', 'Este evento não pode ser favoritado (ID ausente).', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      final eventoId = evento.id;
      if (watchlistIds.contains(eventoId)) {
        await _watchlistService.removerEvento(eventoId);
        Get.snackbar('Removido', '"${evento.tipo}" foi removido da sua watchlist.', snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12),);
      } else {
        await _watchlistService.adicionarEvento(evento);
        Get.snackbar('Adicionado', '"${evento.tipo}" foi adicionado à sua watchlist.', snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12),);
      }
    } catch (e) {
      Get.snackbar('Erro de Rede', 'Não foi possível atualizar sua watchlist. Verifique sua conexão.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white,);
    }
  }

  void logout() async {
    await _autenticacaoService.logout();
    Get.offAllNamed('/login');
  }
}
