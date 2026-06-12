import 'package:flutter/material.dart';
import '../states/ui_state.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();

  UiState<void> _sendState = const UiIdle();
  UiState<void> get sendState => _sendState;

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
      await Future.delayed(const Duration(seconds: 2));
      _setState(const UiSuccess(null));
      return true;
    } catch (e) {
      _setState(
        const UiError('No se pudo enviar el código. Intenta de nuevo.'),
      );
      return false;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
