import 'package:flutter/material.dart';
import '../../../../core/network/http_client.dart';
import '../../data/datasource/remote/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/use_cases/send_forgot_password_use_case.dart';
import '../states/ui_state.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  final SendForgotPasswordUseCase _sendForgotPassword;

  final TextEditingController emailController = TextEditingController();

  UiState<void> _sendState = const UiIdle();
  UiState<void> get sendState => _sendState;

  ForgotPasswordProvider({SendForgotPasswordUseCase? sendForgotPassword})
    : _sendForgotPassword =
          sendForgotPassword ??
          SendForgotPasswordUseCase(
            AuthRepositoryImpl(AuthRemoteDataSource(HttpClient.instance)),
          );

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
    } catch (_) {
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
