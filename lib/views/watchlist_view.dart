import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/watchlist_controller.dart';
import '../models/evento_model.dart';

class WatchlistView extends StatelessWidget {
  final WatchlistController _controller = Get.put(WatchlistController());

  WatchlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Watchlist'),
      ),
      body: Obx(() {
        if (_controller.watchlist.isEmpty) {
          return const Center(
            child: Text(
              'Sua lista de favoritos está vazia.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: _controller.watchlist.length,
          itemBuilder: (context, index) {
            final Evento evento = _controller.watchlist[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                title: Text(evento.tipo, style: const TextStyle(fontWeight: FontWeight.bold)),
                // **CORREÇÃO APLICADA AQUI**
                // Usando um Column para exibir as informações em linhas separadas.
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
                  icon: const Icon(Icons.star, color: Colors.amber),
                  tooltip: 'Remover dos favoritos',
                  onPressed: () => _controller.removerDaWatchlist(evento),
                ),
                onTap: () => Get.toNamed('/detalhes-evento', arguments: evento),
              ),
            );
          },
        );
      }),
    );
  }
}
