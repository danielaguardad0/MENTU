import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../providers/auth_provider.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  final _titleCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  DateTime? _pickedDate;
  String _priority = 'media';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    if (user != null) {
      ref.read(taskProvider.notifier).loadTasks(user.id as int);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider);
    final user = ref.watch(authProvider).user;
    return Scaffold(
      appBar: AppBar(title: const Text('Tareas')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          ElevatedButton.icon(
            onPressed: () => _showCreateDialog(context, int.parse(user!.id)),
            icon: const Icon(Icons.add),
            label: const Text('Crear tarea'),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: tasks.isEmpty
                ? const Center(child: Text('No hay tareas'))
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, i) {
                      final t = tasks[i];
                      return ListTile(
                        title: Text(t.title),
                        subtitle: Text('${t.subject} • ${t.dueDate}'),
                        trailing: Text(t.priority),
                        leading: Checkbox(
                            value: t.completed,
                            onChanged: (v) async {
                              final updated = TaskModel(
                                  id: t.id,
                                  userId: t.userId,
                                  title: t.title,
                                  subject: t.subject,
                                  dueDate: t.dueDate,
                                  priority: t.priority,
                                  completed: v ?? false);
                              await ref
                                  .read(taskProvider.notifier)
                                  .updateTask(updated);
                            }),
                      );
                    },
                  ),
          )
        ]),
      ),
    );
  }

  void _showCreateDialog(BuildContext context, int userId) {
    _titleCtrl.clear();
    _subjectCtrl.clear();
    _pickedDate = DateTime.now();
    _priority = 'media';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Crear tarea'),
        content: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Requerido' : null),
            TextFormField(
                controller: _subjectCtrl,
                decoration: const InputDecoration(labelText: 'Materia'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Requerido' : null),
            const SizedBox(height: 8),
            Row(children: [
              const Text('Fecha: '),
              TextButton(
                  onPressed: () async {
                    final d = await showDatePicker(
                        context: context,
                        initialDate: _pickedDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100));
                    if (d != null) setState(() => _pickedDate = d);
                  },
                  child: Text(_pickedDate != null
                      ? _pickedDate!.toIso8601String().split('T').first
                      : 'Seleccionar')),
            ]),
            DropdownButtonFormField<String>(
              value: _priority,
              items: const [
                DropdownMenuItem(value: 'baja', child: Text('Baja')),
                DropdownMenuItem(value: 'media', child: Text('Media')),
                DropdownMenuItem(value: 'alta', child: Text('Alta')),
              ],
              onChanged: (v) {
                if (v != null) _priority = v;
              },
              decoration: const InputDecoration(labelText: 'Prioridad'),
            )
          ]),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          ElevatedButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                final t = TaskModel(
                  userId: userId,
                  title: _titleCtrl.text.trim(),
                  subject: _subjectCtrl.text.trim(),
                  dueDate: _pickedDate!.toIso8601String().split('T').first,
                  priority: _priority,
                );
                await ref.read(taskProvider.notifier).addTask(t);
                Navigator.pop(context);
              },
              child: const Text('Crear'))
        ],
      ),
    );
  }
}
