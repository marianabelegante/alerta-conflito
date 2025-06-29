import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/eventos_controller.dart';
import '../models/evento_model.dart';

class EventosView extends StatelessWidget {
  final EventosController _controller = Get.put(EventosController());

  EventosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos de Conflito'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_outline),
            tooltip: 'Minha Watchlist',
            onPressed: () => Get.toNamed('/watchlist'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: _controller.logout,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16.0),
              _buildFiltro(),
              const SizedBox(height: 8),
              Obx(() {
                if (_controller.isLoading.value && _controller.eventos.isNotEmpty) {
                  return const LinearProgressIndicator();
                }
                return const SizedBox(height: 4);
              }),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  if (_controller.isLoading.value && _controller.eventos.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (_controller.errorMessage.value.isNotEmpty) {
                    return Center(child: Text(_controller.errorMessage.value, textAlign: TextAlign.center));
                  }
                  if (_controller.eventos.isEmpty) {
                    return const Center(child: Text('Nenhum evento para exibir.'));
                  }
                  return _buildListaEventos();
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFiltro() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller.paisController,
            focusNode: _controller.paisFocusNode,
            decoration: InputDecoration(
              labelText: 'País',
              hintText: 'Filtrar por país',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onSubmitted: (_) => _controller.buscarEventosPorFiltro(),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: _controller.buscarEventosPorFiltro,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Icon(Icons.search),
        ),
      ],
    );
  }

  Widget _buildListaEventos() {
    return ListView.builder(
      itemCount: _controller.eventos.length,
      itemBuilder: (context, index) {
        final Evento evento = _controller.eventos[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 7.0),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Obx(() {
            final bool isFavorito = _controller.watchlistIds.contains(evento.id);
            return ListTile(
              contentPadding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
              title: Text(evento.tipo, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${evento.localizacao}, ${evento.pais}'),
                    const SizedBox(height: 2),
                    Text('Data: ${evento.data}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  isFavorito ? Icons.star : Icons.star_border,
                  color: isFavorito ? Colors.amber : Colors.grey,
                  size: 28,
                ),
                onPressed: () => _controller.toogleWatchlist(evento),
              ),
              onTap: () => Get.toNamed('/detalhes-evento', arguments: evento),
            );
          }),
        );
      },
    );
  }
}
