import 'dart:async';
import '../models/user_model.dart';
import 'package:uuid/uuid.dart';

class ApiService {
  final _users = <String, User>{};

  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    final user = _users.values.firstWhere((u) => u.email == email,
        orElse: () => throw Exception('Usuario no encontrado'));

    return user;
  }

  Future<User> register(String name, String email, String role) async {
    await Future.delayed(const Duration(seconds: 1));

    final id = const Uuid().v4();
    final user = User(id: id, name: name, email: email, role: role);
    _users[id] = user;
    return user;
  }
}
