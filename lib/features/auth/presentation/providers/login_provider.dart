import 'package:flutter/material.dart';
import '../states/ui_state.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  UiState<void> _loginState = const UiIdle();
  UiState<void> get loginState => _loginState;

  bool _isPasswordObscured = true;
  bool get isPasswordObscured => _isPasswordObscured;

  void togglePasswordVisibility() {
    _isPasswordObscured = !_isPasswordObscured;
    notifyListeners();
  }

  void _setState(UiState<void> state) {
    _loginState = state;
    notifyListeners();
  }

  Future<bool> loginWithEmail() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _setState(
        const UiError('Por favor, ingresa tus credenciales completas.'),
      );
      return false;
    }

    _setState(const UiLoading());

    try {
      await Future.delayed(const Duration(seconds: 2));
      _setState(const UiSuccess(null));
      return true;
    } catch (e) {
      _setState(
        const UiError('Credenciales incorrectas o problemas de conexión.'),
      );
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    _setState(const UiLoading());

    try {
      await Future.delayed(const Duration(milliseconds: 1500));
      _setState(const UiSuccess(null));
      return true;
    } catch (e) {
      _setState(const UiError('Ocurrió un error al autenticar con Google.'));
      return false;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
