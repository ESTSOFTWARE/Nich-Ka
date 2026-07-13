import 'package:flutter/material.dart';
import '../../di/auth_dependencies.dart';
import '../../domain/use_cases/send_forgot_password_use_case.dart';
import '../states/ui_state.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  final SendForgotPasswordUseCase _sendForgotPassword;

  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  UiState<void> _sendState = const UiIdle();
  UiState<void> get sendState => _sendState;

  ForgotPasswordProvider({SendForgotPasswordUseCase? sendForgotPassword})
    : _sendForgotPassword =
          sendForgotPassword ?? AuthDependencies.sendForgotPassword;

  void _setState(UiState<void> state) {
    _sendState = state;
    notifyListeners();
  }

  Future<bool> sendCode() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _setState(const UiError('Ingresa tu correo electrónico.'));
      return false;
    }

    _setState(const UiLoading());
    try {
      await _sendForgotPassword(email);
      _setState(const UiSuccess(null));
      return true;
    } catch (e) {
      _setState(UiError(e.toString().replaceFirst('Exception: ', '')));
      return false;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
