import 'package:get/get.dart';
import '../models/evento_model.dart';

class DetalhesEventoController extends GetxController {
  // A variável 'evento' será observável e inicializada como nula.
  final Rx<Evento?> evento = Rx<Evento?>(null);

  @override
  void onInit() {
    super.onInit();
    // Pega o objeto Evento passado como argumento na navegação.
    // O Get.arguments garante que recebemos os dados da tela anterior.
    final eventoRecebido = Get.arguments;
    
    // Verifica se o argumento é do tipo Evento antes de usá-lo.
    if (eventoRecebido is Evento) {
      evento.value = eventoRecebido;
    }
  }
}
