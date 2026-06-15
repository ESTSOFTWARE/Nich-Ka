import 'package:flutter/material.dart';
import '../../../../core/network/http_client.dart';
import '../../data/datasource/remote/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_credentials.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../../domain/use_cases/login_with_google_use_case.dart';
import '../states/ui_state.dart';

class LoginProvider extends ChangeNotifier {
  final LoginUseCase _loginWithEmail;
  final LoginWithGoogleUseCase _loginWithGoogle;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  UiState<void> _loginState = const UiIdle();
  UiState<void> get loginState => _loginState;

  bool _isPasswordObscured = true;
  bool get isPasswordObscured => _isPasswordObscured;

  LoginProvider({
    LoginUseCase? loginWithEmail,
    LoginWithGoogleUseCase? loginWithGoogle,
  }) : _loginWithEmail =
           loginWithEmail ??
           LoginUseCase(
             AuthRepositoryImpl(AuthRemoteDataSource(HttpClient.instance)),
           ),
       _loginWithGoogle =
           loginWithGoogle ??
           LoginWithGoogleUseCase(
             AuthRepositoryImpl(AuthRemoteDataSource(HttpClient.instance)),
           );

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
      await _loginWithEmail(AuthCredentials(email: email, password: password));
      _setState(const UiSuccess(null));
      return true;
    } catch (e) {
      _setState(UiError(e.toString().replaceFirst('Exception: ', '')));
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    _setState(const UiLoading());
    try {
      await _loginWithGoogle();
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
    passwordController.dispose();
    super.dispose();
  }
}
