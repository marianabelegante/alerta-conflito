import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/autenticacao_service.dart';

class LoginController extends GetxController {
  final AutenticacaoService _autenticacaoService = AutenticacaoService();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var isLoading = false.obs;

  void login() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        final user = await _autenticacaoService.login(
          emailController.text,
          senhaController.text,
        );

        if (user != null) {
          Get.offAllNamed('/eventos'); // Redireciona para a tela de eventos
        } else {
          Get.snackbar(
            'Erro',
            'Email ou senha inválidos.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } finally {
        isLoading.value = false;
      }
    }
  }
}
