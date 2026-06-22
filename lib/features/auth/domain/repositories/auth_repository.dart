import '../entities/auth_credentials.dart';
import '../entities/auth_token.dart';

abstract class AuthRepository {
  Future<AuthToken> loginWithEmail(AuthCredentials credentials);
  Future<AuthToken> loginWithGoogle();
  Future<void> sendForgotPassword(String email);
  Future<void> changePassword({required String current, required String next});
  Future<void> logout();
}
