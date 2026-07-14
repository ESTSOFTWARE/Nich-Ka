import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/auth_dependencies.dart';
import '../states/ui_state.dart';

class ForgotPasswordNotifier extends Notifier<UiState<void>> {
  @override
  UiState<void> build() => const UiIdle();

  Future<bool> sendCode(String email) async {
    if (email.isEmpty) {
      state = const UiError('Ingresa tu correo electrónico.');
      return false;
    }
    state = const UiLoading();
    try {
      await AuthDependencies.sendForgotPassword(email);
      state = const UiSuccess(null);
      return true;
    } catch (e) {
      state = UiError(e.toString().replaceFirst('Exception: ', ''));
      return false;
    }
  }
}

final forgotPasswordProvider =
    NotifierProvider<ForgotPasswordNotifier, UiState<void>>(
      ForgotPasswordNotifier.new,
    );
