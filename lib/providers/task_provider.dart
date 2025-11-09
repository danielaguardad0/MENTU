import 'package:flutter_riverpod/legacy.dart';
import '../models/task.dart';
import '../services/task_service.dart';

final taskProvider = StateNotifierProvider<TaskNotifier, List<TaskModel>>(
    (ref) => TaskNotifier());

class TaskNotifier extends StateNotifier<List<TaskModel>> {
  final TaskService _service = TaskService();
  TaskNotifier() : super([]);

  Future<void> loadTasks(int userId) async {
    final list = await _service.getAllForUser(userId);
    state = list;
  }

  Future<void> addTask(TaskModel t) async {
    final created = await _service.create(t);
    state = [...state, created];
  }

  Future<void> updateTask(TaskModel t) async {
    await _service.update(t);
    state = state.map((e) => e.id == t.id ? t : e).toList();
  }

  Future<void> deleteTask(int id) async {
    await _service.delete(id);
    state = state.where((e) => e.id != id).toList();
  }
}
