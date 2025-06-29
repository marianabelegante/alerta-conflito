import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/evento_model.dart';

class MapaController extends GetxController {
  late final Evento evento;
  late final CameraPosition cameraInicial;
  final RxSet<Marker> marcadores = <Marker>{}.obs;

  @override
  void onInit() {
    super.onInit();
    final eventoRecebido = Get.arguments;

    if (eventoRecebido is Evento) {
      evento = eventoRecebido;
      
      final lat = double.tryParse(evento.latitude) ?? 0.0;
      final lon = double.tryParse(evento.longitude) ?? 0.0;

      cameraInicial = CameraPosition(
        target: LatLng(lat, lon),
        zoom: 8.0,
      );

      _criarMarcador(lat, lon);
    } else {
      cameraInicial = const CameraPosition(
        target: LatLng(0, 0),
        zoom: 2,
      );
      Get.snackbar('Erro', 'Não foi possível carregar a localização do evento.');
    }
  }

  void _criarMarcador(double lat, double lon) {
    marcadores.add(
      Marker(
        markerId: MarkerId(evento.id),
        position: LatLng(lat, lon),
        infoWindow: InfoWindow(
          title: evento.tipo,
          snippet: '${evento.localizacao}, ${evento.pais}',
        ),
      ),
    );
  }
}
