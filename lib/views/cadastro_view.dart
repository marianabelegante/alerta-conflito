import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cadastro_controller.dart';

class CadastroView extends StatelessWidget {
  final CadastroController _controller = Get.put(CadastroController());

  CadastroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _controller.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _controller.emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty || !GetUtils.isEmail(value)) {
                    return 'Por favor, insira um email válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _controller.senhaController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return 'A senha deve ter pelo menos 6 caracteres.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              Obx(() => _controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _controller.cadastrar,
                      child: const Text('Cadastrar'),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
