import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/comentarios_controller.dart';
import '../models/comentario_model.dart';
import '../models/evento_model.dart';

class ComentariosView extends StatelessWidget {
  final ComentariosController _controller = Get.put(ComentariosController());

  ComentariosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comentários do Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoEvento(_controller.evento),
            const Divider(height: 30),
            _buildCampoComentario(),
            const SizedBox(height: 20),
            _buildListaComentarios(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoEvento(Evento evento) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(evento.tipo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Text('${evento.localizacao}, ${evento.pais} - ${evento.data}'),
          ],
        ),
      ),
    );
  }

  Widget _buildCampoComentario() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller.textController,
            decoration: InputDecoration(
              hintText: 'Digite seu comentário pessoal...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: const Icon(Icons.send, color: Colors.blue),
          onPressed: _controller.adicionarComentario,
          tooltip: 'Salvar comentário',
        ),
      ],
    );
  }

  Widget _buildListaComentarios() {
    return Expanded(
      // **A LÓGICA DA VIEW NÃO MUDA**
      // O Obx continua observando o getter `_controller.comentarios`.
      // A diferença é que agora esse getter busca os dados diretamente do modelo do evento.
      child: Obx(() {
        if (_controller.comentarios.isEmpty) {
          return const Center(child: Text('Nenhum comentário ainda.'));
        }
        // Ordena para mostrar o mais recente primeiro.
        final comentariosOrdenados = _controller.comentarios.toList()..sort((a, b) => b.dataHora.compareTo(a.dataHora));
        return ListView.builder(
          itemCount: comentariosOrdenados.length,
          itemBuilder: (context, index) {
            final ComentarioModel comentario = comentariosOrdenados[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                title: Text(comentario.texto),
                subtitle: Text(
                  _controller.formatarData(comentario.dataHora),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
