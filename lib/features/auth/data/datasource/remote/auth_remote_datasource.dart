import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../core/network/http_client.dart';
import '../../../domain/entities/auth_credentials.dart';
import '../../../domain/entities/auth_token.dart';
import 'model/dto/response/login_response_dto.dart';
import 'mapper/auth_mapper.dart';

class AuthRemoteDataSource {
  final HttpClient _client;

  const AuthRemoteDataSource(this._client);

  Future<AuthToken> loginWithEmail(AuthCredentials credentials) async {
    final dto = AuthMapper.toLoginRequest(credentials);
    final response = await _client.post('/auth/login', dto.toJson());

    _assertSuccess(response, 'Credenciales incorrectas.');

    final loginDto = LoginResponseDto.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
    _client.setTokens(
      access: loginDto.accessToken,
      refresh: loginDto.refreshToken,
    );
    return AuthMapper.fromLoginResponse(loginDto);
  }

  Future<AuthToken> loginWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return const AuthToken(
      token: 'mock-google-token',
      userId: 0,
      name: 'Google',
      lastName: 'User',
      email: 'user@gmail.com',
      role: 'estudiante',
      oauthProvider: 'google',
    );
  }

  Future<void> sendForgotPassword(String email) async {
    final dto = AuthMapper.toForgotPasswordRequest(email);
    final response = await _client.post('/auth/forgot-password', dto.toJson());
    _assertSuccess(response, 'No se pudo enviar el código. Intenta de nuevo.');
  }

  Future<void> changePassword({
    required String current,
    required String next,
  }) async {
    final dto = AuthMapper.toChangePasswordRequest(
      current: current,
      next: next,
    );
    final response = await _client.post(
      '/users/me/change-password',
      dto.toJson(),
    );
    _assertSuccess(response, 'No se pudo cambiar la contraseña.');
  }

  Future<void> logout() async {
    final response = await _client.post('/auth/logout', {});
    if (response.statusCode >= 200 && response.statusCode < 300) {
      _client.clearTokens();
    }
  }

  void _assertSuccess(http.Response response, String fallbackMessage) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final detail = body['detail'];
      final message = detail is String ? detail : fallbackMessage;
      throw Exception(message);
    }
  }
}
