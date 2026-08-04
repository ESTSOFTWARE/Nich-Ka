import '../../features/auth/domain/entities/auth_token.dart';

/// Estado de sesión global. Inmutable: [user] nulo = sin sesión.
class AuthState {
  final AuthToken? user;

  const AuthState({this.user});

  bool get isLoggedIn => user != null;
  String get role => user?.role ?? '';
  int? get userId => user?.userId;
  String get displayName =>
      user != null ? '${user!.name} ${user!.lastName}' : '';
}
