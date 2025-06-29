import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/detalhes_evento_controller.dart';
import '../models/evento_model.dart';

class DetalhesEventoView extends StatelessWidget {
  final DetalhesEventoController _controller = Get.put(DetalhesEventoController());

  DetalhesEventoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Evento'),
      ),
      body: Obx(() {
        final evento = _controller.evento.value;
        if (evento == null) {
          return const Center(child: Text('Nenhum evento para exibir.'));
        }
        return _buildDetalhes(context, evento);
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed('/comentarios-evento', arguments: _controller.evento.value),
        label: const Text('Comentários'),
        icon: const Icon(Icons.comment),
      ),
    );
  }

  Widget _buildDetalhes(BuildContext context, Evento evento) {
    final bool temCoordenadasValidas = 
        (double.tryParse(evento.latitude) != null && double.tryParse(evento.longitude) != null) &&
        (evento.latitude != '0.0' && evento.longitude != '0.0');

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                evento.tipo,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Ocorrido em ${evento.localizacao}, ${evento.pais}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
              ),
              const Divider(height: 30),
              _buildInfoTile(
                icon: Icons.calendar_today,
                titulo: 'Data',
                valor: evento.data,
              ),
              _buildInfoTile(
                icon: Icons.person_remove,
                titulo: 'Fatalidades',
                valor: evento.fatalidades.toString(),
              ),
              _buildInfoTile(
                icon: Icons.location_on,
                titulo: 'Coordenadas',
                valor: 'Lat: ${evento.latitude}, Lon: ${evento.longitude}',
              ),
              _buildInfoTile(
                icon: Icons.source,
                titulo: 'Fonte da Informação',
                valor: evento.fonte,
                isSelectable: true,
              ),
              const Divider(height: 30),
              if (temCoordenadasValidas)
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.map),
                    label: const Text('Ver no mapa'),
                    onPressed: () => Get.toNamed('/mapa-evento', arguments: evento),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                'Descrição do Evento',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SelectableText(
                evento.descricao,
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({required IconData icon, required String titulo, required String valor, bool isSelectable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue.shade700, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                isSelectable
                    ? SelectableText(valor, style: TextStyle(fontSize: 15, color: Colors.grey[800]))
                    : Text(valor, style: TextStyle(fontSize: 15, color: Colors.grey[800])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
