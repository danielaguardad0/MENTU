import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../core/db_helper.dart';
import '../models/user.dart';

class AuthService {
  // Hash simple con sha256 + salt (suficiente para proyecto educativo)
  String _hashPassword(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserModel?> register(String email, String password, String role,
      {String? name}) async {
    final db = await DBHelper.instance.database;
    final salt = 'mentu_salt';
    final hash = _hashPassword(password, salt);
    final user =
        UserModel(email: email, name: name, passwordHash: hash, role: role);
    try {
      final id = await db.insert('users', user.toMap());
      user.id = id;
      return user;
    } catch (e) {
      // email duplicado -> retorna null
      return null;
    }
  }

  Future<UserModel?> login(String email, String password) async {
    final db = await DBHelper.instance.database;
    final salt = 'mentu_salt';
    final hash = _hashPassword(password, salt);
    final res = await db.query('users',
        where: 'email = ?', whereArgs: [email], limit: 1);
    if (res.isEmpty) return null;
    final u = UserModel.fromMap(res.first);
    if (u.passwordHash == hash) return u;
    return null;
  }

  Future<UserModel?> getById(int id) async {
    final db = await DBHelper.instance.database;
    final res =
        await db.query('users', where: 'id = ?', whereArgs: [id], limit: 1);
    if (res.isEmpty) return null;
    return UserModel.fromMap(res.first);
  }

  Future<List<UserModel>> getTutorsBySubject(String subject) async {
    // simple: return all tutors — filtering por materia requiere campo materias en user
    final db = await DBHelper.instance.database;
    final rows =
        await db.query('users', where: 'role = ?', whereArgs: ['tutor']);
    return rows.map((r) => UserModel.fromMap(r)).toList();
  }
}
