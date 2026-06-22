import '../../domain/entities/auth_credentials.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasource/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;

  const AuthRepositoryImpl(this._dataSource);

  @override
  Future<AuthToken> loginWithEmail(AuthCredentials credentials) =>
      _dataSource.loginWithEmail(credentials);

  @override
  Future<AuthToken> loginWithGoogle() => _dataSource.loginWithGoogle();

  @override
  Future<void> sendForgotPassword(String email) =>
      _dataSource.sendForgotPassword(email);

  @override
  Future<void> changePassword({
    required String current,
    required String next,
  }) => _dataSource.changePassword(current: current, next: next);

  @override
  Future<void> logout() => _dataSource.logout();
}
