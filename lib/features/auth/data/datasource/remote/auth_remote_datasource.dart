import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../../core/network/http_client.dart';
import '../../../../../core/auth/session_manager.dart';
import '../../../domain/entities/auth_credentials.dart';
import '../../../domain/entities/auth_token.dart';
import 'model/dto/response/login_response_dto.dart';
import 'mapper/auth_mapper.dart';

class AuthRemoteDataSource {
  final HttpClient _client;

  // Cliente OAuth **Web** (mismo que GOOGLE_CLIENT_ID del backend). Se usa como
  // serverClientId para que el id_token traiga aud = este id, que el backend valida.
  static const String _googleServerClientId =
      '811899751140-04kfrfnpdledl3ieceif4epk271q3tgn.apps.googleusercontent.com';

  const AuthRemoteDataSource(this._client);

  Future<AuthToken> loginWithEmail(AuthCredentials credentials) async {
    final dto = AuthMapper.toLoginRequest(credentials);
    final response = await _client.post('/auth/login', dto.toJson());

    _assertSuccess(response, 'Credenciales incorrectas.');

    final loginDto = LoginResponseDto.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
    final token = AuthMapper.fromLoginResponse(loginDto);
    _client.setTokens(
      access: loginDto.accessToken,
      refresh: loginDto.refreshToken,
      userId: token.userId,
    );
    // Guarda la sesión para volver a entrar con huella.
    await SessionManager.instance.save(token, loginDto.refreshToken);
    return token;
  }

  Future<AuthToken> loginWithGoogle() async {
    // 1. Sign-In nativo de Google → id_token (aud = serverClientId Web)
    final googleSignIn = GoogleSignIn(
      serverClientId: _googleServerClientId,
      scopes: const ['email', 'profile'],
    );
    // Cierra sesión previa para que siempre muestre el selector de cuenta
    await googleSignIn.signOut();

    final account = await googleSignIn.signIn();
    if (account == null) {
      throw Exception('Inicio de sesión con Google cancelado.');
    }

    final auth = await account.authentication;
    final idToken = auth.idToken;
    if (idToken == null) {
      throw Exception('No se pudo obtener el token de Google.');
    }

    // 2. El backend valida el token y SOLO deja entrar si el correo ya existe
    final response = await _client.post('/auth/google/mobile', {
      'id_token': idToken,
    });

    if (response.statusCode == 401 || response.statusCode == 403) {
      // Cierra la sesión de Google para no dejarla “pegada”
      await googleSignIn.signOut();
      throw Exception(
        'Tu correo no está registrado. Pide a tu administrador o docente que te dé de alta.',
      );
    }
    _assertSuccess(response, 'No se pudo iniciar sesión con Google.');

    // 3. Mismo formato que el login normal → guardar tokens
    final loginDto = LoginResponseDto.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
    final token = AuthMapper.fromLoginResponse(loginDto);
    _client.setTokens(
      access: loginDto.accessToken,
      refresh: loginDto.refreshToken,
      userId: token.userId,
    );
    // Guarda la sesión para volver a entrar con huella.
    await SessionManager.instance.save(token, loginDto.refreshToken);
    return token;
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
    // Siempre borra la sesión guardada (para que no vuelva a entrar con huella).
    await SessionManager.instance.clear();
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
