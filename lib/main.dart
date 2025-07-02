import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'firebase_options.dart';
import 'routes.dart';
import 'services/autenticacao_service.dart';
import 'services/watchlist_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  await Hive.openBox('eventosBox');
  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  
  // Garante que a instância do WatchlistService
  // seja registrada permanentemente assim que o app inicia.
  Get.put<WatchlistService>(WatchlistService(), permanent: true);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final autenticacaoService = AutenticacaoService();
    final bool isUserLoggedIn = autenticacaoService.usuarioLogado != null;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alerta de Conflito',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: isUserLoggedIn ? '/eventos' : '/login',
      getPages: AppRoutes.routes,
    );
  }
}
