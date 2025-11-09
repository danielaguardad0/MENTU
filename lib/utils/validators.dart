bool isValidEmail(String email) {
  final regex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
  return regex.hasMatch(email);
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) return 'La contraseña es obligatoria';
  if (value.length < 6) return 'La contraseña debe tener al menos 6 caracteres';
  return null;
}
