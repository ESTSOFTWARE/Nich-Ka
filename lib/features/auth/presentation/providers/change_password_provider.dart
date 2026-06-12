import 'package:flutter/material.dart';
import '../states/ui_state.dart';

class ChangePasswordProvider extends ChangeNotifier {
  final TextEditingController currentController = TextEditingController();
  final TextEditingController newController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  bool _currentObscured = true;
  bool _newObscured = true;
  bool _confirmObscured = true;

  bool get currentObscured => _currentObscured;
  bool get newObscured => _newObscured;
  bool get confirmObscured => _confirmObscured;

  UiState<void> _state = const UiIdle();
  UiState<void> get state => _state;

  void toggleCurrentObscured() {
    _currentObscured = !_currentObscured;
    notifyListeners();
  }

  void toggleNewObscured() {
    _newObscured = !_newObscured;
    notifyListeners();
  }

  void toggleConfirmObscured() {
    _confirmObscured = !_confirmObscured;
    notifyListeners();
  }

  void _setState(UiState<void> value) {
    _state = value;
    notifyListeners();
  }

  Future<bool> submit() async {
    final current = currentController.text.trim();
    final next = newController.text.trim();
    final confirm = confirmController.text.trim();

    if (current.isEmpty || next.isEmpty || confirm.isEmpty) {
      _setState(const UiError('Completa todos los campos.'));
      return false;
    }
    if (next.length < 6) {
      _setState(
        const UiError('La nueva contraseña debe tener al menos 6 caracteres.'),
      );
      return false;
    }
    if (next != confirm) {
      _setState(const UiError('Las contraseñas no coinciden.'));
      return false;
    }

    _setState(const UiLoading());
    try {
      await Future.delayed(const Duration(seconds: 2));
      _setState(const UiSuccess(null));
      return true;
    } catch (e) {
      _setState(
        const UiError('No se pudo cambiar la contraseña. Intenta de nuevo.'),
      );
      return false;
    }
  }

  @override
  void dispose() {
    currentController.dispose();
    newController.dispose();
    confirmController.dispose();
    super.dispose();
  }
}
