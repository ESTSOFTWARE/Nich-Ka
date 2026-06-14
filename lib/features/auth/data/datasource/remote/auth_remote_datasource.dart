import '../../../../../core/network/http_client.dart';
import '../../../domain/entities/auth_credentials.dart';
import '../../../domain/entities/auth_token.dart';

class AuthRemoteDataSource {
  // ignore: unused_field
  final HttpClient _client;

  const AuthRemoteDataSource(this._client);

  Future<AuthToken> loginWithEmail(AuthCredentials credentials) async {
    await Future.delayed(const Duration(milliseconds: 800));
    const validEmail = 'nichka@nich-ka.space';
    const validPassword = 'NichKa2026';
    if (credentials.email == validEmail &&
        credentials.password == validPassword) {
      return const AuthToken(token: 'mock-token-123');
    }
    throw Exception('Credenciales incorrectas.');
  }

  Future<AuthToken> loginWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return const AuthToken(token: 'mock-google-token-456');
  }

  Future<void> sendForgotPassword(String email) async {
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> changePassword({
    required String current,
    required String next,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
  }
}
