import '../entities/auth_token.dart';
import '../repositories/auth_repository.dart';

class LoginWithGoogleUseCase {
  final AuthRepository _repository;

  const LoginWithGoogleUseCase(this._repository);

  Future<AuthToken> call() => _repository.loginWithGoogle();
}
