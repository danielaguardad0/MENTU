// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../utils/validators.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  static final TextEditingController _emailCtrl = TextEditingController();
  static final TextEditingController _nameCtrl = TextEditingController();
  static final TextEditingController _passCtrl = TextEditingController();
  static String _role = 'student';
  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mentu - Registrarse')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: 'Correo'),
              validator: (v) => (v == null || v.isEmpty)
                  ? 'Correo obligatorio'
                  : (!isValidEmail(v) ? 'Correo inválido' : null),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Nombre (opcional)'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              validator: passwordValidator,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _role,
              items: const [
                DropdownMenuItem(value: 'student', child: Text('Estudiante')),
                DropdownMenuItem(value: 'tutor', child: Text('Tutor')),
              ],
              onChanged: (v) {
                if (v != null) _role = v;
              },
              decoration: const InputDecoration(labelText: 'Rol'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: auth.isLoading
                  ? null
                  : () async {
                      if (!_formKey.currentState!.validate()) return;

                      await ref.read(authProvider.notifier).register(
                            _nameCtrl.text.trim(),
                            _emailCtrl.text.trim(),
                            _role,
                          );

                      final user = ref.read(authProvider).user;
                      if (user != null) {
                        Navigator.pop(context);
                      } else {
                        final err = ref.read(authProvider).error ?? 'Error';
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(err)));
                      }
                    },
              child: auth.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Crear cuenta'),
            )
          ]),
        ),
      ),
    );
  }
}
