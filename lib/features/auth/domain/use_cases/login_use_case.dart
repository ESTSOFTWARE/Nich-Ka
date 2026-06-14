import '../entities/auth_credentials.dart';
import '../entities/auth_token.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  const LoginUseCase(this._repository);

  Future<AuthToken> call(AuthCredentials credentials) =>
      _repository.loginWithEmail(credentials);
}
