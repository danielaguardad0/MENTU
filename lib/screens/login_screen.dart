import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Mentu - Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (auth.isLoading) const CircularProgressIndicator(),
            TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Correo')),
            TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(authProvider.notifier).login(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
              },
              child: const Text('Iniciar sesión'),
            ),
            if (auth.error != null)
              Text(auth.error!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
