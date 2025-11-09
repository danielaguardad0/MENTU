import 'package:mentu_app/models/user_model.dart';
import 'package:riverpod/legacy.dart';
import '../services/api_service.dart';

/// Estado del usuario
class AuthState {
  final bool isLoading;
  final User? user;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    User? user,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }
}

/// Notifier que maneja la autenticación
class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService api;

  AuthNotifier(this.api) : super(const AuthState());

  /// Login
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await api.login(email, password);
      state = state.copyWith(isLoading: false, user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Logout
  void logout() => state = const AuthState();

  /// Registro de usuario
  Future<void> register(String name, String email, String role) async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await api.register(name, email, role);
      state = state.copyWith(isLoading: false, user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

/// Provider principal
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ApiService()),
);
