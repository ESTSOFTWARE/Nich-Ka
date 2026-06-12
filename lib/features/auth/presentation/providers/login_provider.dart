import 'package:flutter/material.dart';
import '../states/ui_state.dart';

class LoginProvider extends ChangeNotifier {
  // Controladores de texto para los inputs
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Estado de la operación de login (idle / loading / success / error).
  UiState<void> _loginState = const UiIdle();
  UiState<void> get loginState => _loginState;

  // Estado de visibilidad de la contraseña (lo posee el provider, no el widget).
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

  // Lógica para Login convencional
  Future<bool> loginWithEmail() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _setState(const UiError('Por favor, ingresa tus credenciales completas.'));
      return false;
    }

    _setState(const UiLoading());

    try {
      // Nota: Aquí se inyectará el Use Case en las siguientes etapas del proyecto
      await Future.delayed(const Duration(seconds: 2)); // Simulando petición de red
      _setState(const UiSuccess(null));
      return true;
    } catch (e) {
      _setState(const UiError('Credenciales incorrectas o problemas de conexión.'));
      return false;
    }
  }

  // Lógica para Login con Google
  Future<bool> loginWithGoogle() async {
    _setState(const UiLoading());

    try {
      // Nota: Aquí se llamará al contrato del repositorio/servicio de Google Auth
      await Future.delayed(const Duration(milliseconds: 1500)); // Simulando flujo OAuth
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
