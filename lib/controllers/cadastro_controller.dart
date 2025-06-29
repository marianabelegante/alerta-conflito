import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/autenticacao_service.dart';

class CadastroController extends GetxController {
  final AutenticacaoService _autenticacaoService = AutenticacaoService();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var isLoading = false.obs;

  void cadastrar() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        final user = await _autenticacaoService.cadastrar(
          emailController.text,
          senhaController.text,
        );

        if (user != null) {
          Get.offAllNamed('/home');
        } else {
          Get.snackbar(
            'Erro',
            'Não foi possível realizar o cadastro. Tente novamente.',
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
