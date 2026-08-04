import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/domain/entities/auth_token.dart';
import 'auth_state.dart';

export 'auth_state.dart';

/// Sesión global del usuario. Reemplaza al antiguo AuthProvider (ChangeNotifier).
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  void setUser(AuthToken token) => state = AuthState(user: token);

  void clearUser() => state = const AuthState();
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
