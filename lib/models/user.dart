class UserModel {
  int? id;
  String email;
  String? name;
  String passwordHash;
  String role; // 'student' or 'tutor'

  UserModel({
    this.id,
    required this.email,
    this.name,
    required this.passwordHash,
    required this.role,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'name': name,
        'password_hash': passwordHash,
        'role': role,
      };

  factory UserModel.fromMap(Map<String, dynamic> m) => UserModel(
        id: m['id'] as int?,
        email: m['email'] as String,
        name: m['name'] as String?,
        passwordHash: m['password_hash'] as String,
        role: m['role'] as String,
      );
}
