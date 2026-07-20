import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/auth/session_manager.dart';
import '../../../../core/network/http_client.dart';
import '../../di/auth_dependencies.dart';
import '../../domain/entities/auth_credentials.dart';
import '../../domain/entities/auth_token.dart';
import '../states/ui_state.dart';
import 'login_state.dart';

/// Roles con acceso a la app móvil: solo estudiantes. Admin, profesor y
/// soporte usan la plataforma web.
const _allowedRoles = {'estudiante'};

class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  void togglePasswordVisibility() =>
      state = state.copyWith(isPasswordObscured: !state.isPasswordObscured);

  /// El login ya guardó sesión y tokens; si el rol no está permitido hay que
  /// deshacer eso antes de rechazar, o quedaría una sesión activa a medias.
  Future<void> _ensureAllowedRole(AuthToken token) async {
    if (_allowedRoles.contains(token.role)) return;
    HttpClient.instance.clearTokens();
    await SessionManager.instance.clear();
    throw Exception(
      'El rol "${token.role}" no tiene acceso a la aplicación móvil. '
      'Solo los estudiantes pueden iniciar sesión aquí.',
    );
  }

  Future<bool> loginWithEmail(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      state = state.copyWith(
        status: const UiError('Por favor, ingresa tus credenciales completas.'),
      );
      return false;
    }
    state = state.copyWith(status: const UiLoading());
    try {
      final token = await AuthDependencies.loginWithEmail(
        AuthCredentials(email: email, password: password),
      );
      await _ensureAllowedRole(token);
      state = LoginState(
        status: const UiSuccess(null),
        token: token,
        isPasswordObscured: state.isPasswordObscured,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        status: UiError(e.toString().replaceFirst('Exception: ', '')),
      );
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    state = state.copyWith(status: const UiLoading());
    try {
      final token = await AuthDependencies.loginWithGoogle();
      await _ensureAllowedRole(token);
      state = LoginState(
        status: const UiSuccess(null),
        token: token,
        isPasswordObscured: state.isPasswordObscured,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        status: UiError(e.toString().replaceFirst('Exception: ', '')),
      );
      return false;
    }
  }
}

final loginProvider = NotifierProvider<LoginNotifier, LoginState>(
  LoginNotifier.new,
);
