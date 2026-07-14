import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/auth_dependencies.dart';
import '../../domain/entities/auth_credentials.dart';
import '../states/ui_state.dart';
import 'login_state.dart';

class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  void togglePasswordVisibility() =>
      state = state.copyWith(isPasswordObscured: !state.isPasswordObscured);

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
