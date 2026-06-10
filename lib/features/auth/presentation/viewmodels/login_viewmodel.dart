import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  // Controladores de texto para los inputs (SRP)
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  // Getters públicos para que la UI los consuma de forma segura
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners(); // Notifica los cambios a los widgets que estén escuchando
  }

  void _setErrorMessage(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  // Lógica para Login convencional
  Future<bool> loginWithEmail() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _setErrorMessage('Por favor, ingresa tus credenciales completas.');
      return false;
    }

    _setLoading(true);
    _setErrorMessage(null);

    try {
      // Nota: Aquí se inyectará el Use Case en las siguientes etapas del proyecto
      await Future.delayed(const Duration(seconds: 2)); // Simulando petición de red
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setErrorMessage('Credenciales incorrectas o problemas de conexión.');
      return false;
    }
  }

  // Lógica para Login con Google (Requerimiento explícito del ticket)
  Future<bool> loginWithGoogle() async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      // Nota: Aquí se llamará al contrato del repositorio/servicio de Google Auth
      await Future.delayed(const Duration(milliseconds: 1500)); // Simulando flujo OAuth
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setErrorMessage('Ocurrió un error al autenticar con Google.');
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