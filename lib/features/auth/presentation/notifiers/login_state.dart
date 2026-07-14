import '../../domain/entities/auth_token.dart';
import '../states/ui_state.dart';

class LoginState {
  final UiState<void> status;
  final AuthToken? token;
  final bool isPasswordObscured;

  const LoginState({
    this.status = const UiIdle(),
    this.token,
    this.isPasswordObscured = true,
  });

  LoginState copyWith({
    UiState<void>? status,
    AuthToken? token,
    bool? isPasswordObscured,
  }) => LoginState(
    status: status ?? this.status,
    token: token ?? this.token,
    isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
  );
}
