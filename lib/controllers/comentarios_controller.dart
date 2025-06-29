import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/comentario_model.dart';
import '../models/evento_model.dart';
import '../services/comentarios_service.dart'; // Importa o novo serviço

class ComentariosController extends GetxController {
  late final Evento evento;
  final TextEditingController textController = TextEditingController();
  // Instancia o novo serviço de comentários
  final ComentariosService _comentariosService = ComentariosService();

  // A lista de comentários agora é um RxList que será preenchido pelo stream do Firestore
  final RxList<ComentarioModel> comentarios = <ComentarioModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    final eventoRecebido = Get.arguments;
    if (eventoRecebido is Evento) {
      evento = eventoRecebido;
      // Inicia a escuta (bind) do stream de comentários do Firestore.
      // Qualquer mudança no banco de dados será refletida automaticamente na lista 'comentarios'.
      comentarios.bindStream(_comentariosService.getComentariosStream(evento.id));
    } else {
      evento = Evento(id: '', pais: 'Erro', data: '', tipo: 'Evento não encontrado', fatalidades: 0, localizacao: '', descricao: '', fonte: '', latitude: '', longitude: '');
      Get.snackbar('Erro', 'Não foi possível carregar os detalhes do evento.');
    }
  }

  void adicionarComentario() async {
    final texto = textController.text.trim();
    if (texto.isEmpty) {
      Get.snackbar('Atenção', 'O campo de comentário não pode estar vazio.');
      return;
    }

    try {
      // Chama o serviço para adicionar o comentário no Firestore.
      await _comentariosService.adicionarComentario(evento.id, texto);
      textController.clear();
      Get.focusScope?.unfocus();
      Get.snackbar('Sucesso', 'Seu comentário foi salvo.', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível salvar o comentário: ${e.toString()}', snackPosition: SnackPosition.BOTTOM);
    }
  }

  String formatarData(DateTime data) {
    return DateFormat("dd/MM/yyyy 'às' HH:mm").format(data);
  }
}
