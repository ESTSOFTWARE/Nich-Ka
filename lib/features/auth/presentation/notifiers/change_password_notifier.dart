import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/auth_dependencies.dart';
import '../states/ui_state.dart';
import 'change_password_state.dart';

class ChangePasswordNotifier extends Notifier<ChangePasswordState> {
  @override
  ChangePasswordState build() => const ChangePasswordState();

  void toggleCurrentObscured() =>
      state = state.copyWith(currentObscured: !state.currentObscured);

  void toggleNewObscured() =>
      state = state.copyWith(newObscured: !state.newObscured);

  void toggleConfirmObscured() =>
      state = state.copyWith(confirmObscured: !state.confirmObscured);

  Future<bool> submit({
    required String current,
    required String next,
    required String confirm,
  }) async {
    if (current.isEmpty || next.isEmpty || confirm.isEmpty) {
      state = state.copyWith(
        status: const UiError('Completa todos los campos.'),
      );
      return false;
    }
    if (next.length < 6) {
      state = state.copyWith(
        status: const UiError(
          'La nueva contraseña debe tener al menos 6 caracteres.',
        ),
      );
      return false;
    }
    if (next != confirm) {
      state = state.copyWith(
        status: const UiError('Las contraseñas no coinciden.'),
      );
      return false;
    }
    state = state.copyWith(status: const UiLoading());
    try {
      await AuthDependencies.changePassword(current: current, next: next);
      state = state.copyWith(status: const UiSuccess(null));
      return true;
    } catch (e) {
      state = state.copyWith(
        status: UiError(e.toString().replaceFirst('Exception: ', '')),
      );
      return false;
    }
  }
}

final changePasswordProvider =
    NotifierProvider<ChangePasswordNotifier, ChangePasswordState>(
      ChangePasswordNotifier.new,
    );
