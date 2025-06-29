import 'package:get/get.dart';
import 'views/login_view.dart';
import 'views/cadastro_view.dart';
import 'views/eventos_view.dart';
import 'views/detalhes_evento_view.dart';
import 'views/watchlist_view.dart';
import 'views/comentarios_view.dart';
import 'views/mapa_view.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/login', page: () => LoginView()),
    GetPage(name: '/cadastro', page: () => CadastroView()),
    GetPage(name: '/eventos', page: () => EventosView()),
    GetPage(name: '/detalhes-evento', page: () => DetalhesEventoView()),
    GetPage(name: '/watchlist', page: () => WatchlistView()),
    GetPage(name: '/comentarios-evento', page: () => ComentariosView()),
    GetPage(name: '/mapa-evento', page: () => MapaView()),
  ];
}
