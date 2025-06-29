import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/mapa_controller.dart';

class MapaView extends StatelessWidget {
  final MapaController _controller = Get.put(MapaController());

  MapaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local do Conflito'),
      ),
      body: Obx(() => GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _controller.cameraInicial,
          markers: _controller.marcadores.value,
        ),
      ),
    );
  }
}
