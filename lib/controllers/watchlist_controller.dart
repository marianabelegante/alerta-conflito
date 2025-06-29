import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/evento_model.dart';
import '../services/watchlist_service.dart';

class WatchlistController extends GetxController {
  // Encontra a instância real do serviço que usa Firestore.
  final WatchlistService _watchlistService = Get.find<WatchlistService>();

  // A lista de eventos da watchlist que será preenchida pelo stream.
  final RxList<Evento> watchlist = <Evento>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Inicia a escuta (bind) do stream de eventos favoritados do Firestore.
    // Qualquer mudança no banco de dados será refletida aqui automaticamente.
    watchlist.bindStream(_watchlistService.getWatchlist());
  }

  void removerDaWatchlist(Evento evento) async {
    try {
      await _watchlistService.removerEvento(evento.id);
      Get.snackbar(
        'Removido',
        '"${evento.tipo}" foi removido da sua watchlist.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
      );
    } catch (e) {
      Get.snackbar(
        'Erro de Rede',
        'Não foi possível remover o evento. Verifique sua conexão.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
