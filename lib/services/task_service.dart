import '../core/db_helper.dart';
import '../models/task.dart';

class TaskService {
  Future<TaskModel> create(TaskModel t) async {
    final db = await DBHelper.instance.database;
    final id = await db.insert('tasks', t.toMap());
    t.id = id;
    return t;
  }

  Future<List<TaskModel>> getAllForUser(int userId) async {
    final db = await DBHelper.instance.database;
    final rows = await db.query('tasks',
        where: 'user_id = ?', whereArgs: [userId], orderBy: 'due_date ASC');
    return rows.map((r) => TaskModel.fromMap(r)).toList();
  }

  Future<TaskModel?> getById(int id) async {
    final db = await DBHelper.instance.database;
    final rows =
        await db.query('tasks', where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;
    return TaskModel.fromMap(rows.first);
  }

  Future<TaskModel> update(TaskModel t) async {
    final db = await DBHelper.instance.database;
    await db.update('tasks', t.toMap(), where: 'id = ?', whereArgs: [t.id]);
    return t;
  }

  Future<void> delete(int id) async {
    final db = await DBHelper.instance.database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
