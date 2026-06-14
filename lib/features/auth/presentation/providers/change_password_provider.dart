import 'package:flutter/material.dart';
import '../../../../core/network/http_client.dart';
import '../../data/datasource/remote/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/use_cases/change_password_use_case.dart';
import '../states/ui_state.dart';

class ChangePasswordProvider extends ChangeNotifier {
  final ChangePasswordUseCase _changePassword;

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

  ChangePasswordProvider({ChangePasswordUseCase? changePassword})
    : _changePassword =
          changePassword ??
          ChangePasswordUseCase(
            AuthRepositoryImpl(AuthRemoteDataSource(HttpClient.instance)),
          );

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
      await _changePassword(current: current, next: next);
      _setState(const UiSuccess(null));
      return true;
    } catch (_) {
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
