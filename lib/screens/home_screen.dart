import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'tasks_screen.dart';
import 'tutors_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Mentu - Inicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              ref.read(authProvider.notifier).logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hola, ${user?.name ?? user?.email ?? 'Usuario'}',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const TasksScreen())),
              icon: const Icon(Icons.checklist),
              label: const Text('Mis tareas'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const TutorsScreen())),
              icon: const Icon(Icons.person_search),
              label: const Text('Tutorías y reservas'),
            ),
          ],
        ),
      ),
    );
  }
}
