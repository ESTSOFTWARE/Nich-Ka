import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/domain/entities/auth_token.dart';
import '../network/http_client.dart';

/// Guarda la sesión (refresh token + datos del usuario) de forma segura para
/// permitir volver a entrar con huella sin re-loguearse.
class SessionManager {
  SessionManager._();
  static final SessionManager instance = SessionManager._();

  static const _key = 'saved_session';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> save(AuthToken token, String refreshToken) async {
    final data = {
      'refresh': refreshToken,
      'userId': token.userId,
      'name': token.name,
      'lastName': token.lastName,
      'email': token.email,
      'role': token.role,
      'profileImage': token.profileImage,
      'oauthProvider': token.oauthProvider,
    };
    await _storage.write(key: _key, value: jsonEncode(data));
  }

  Future<bool> hasSession() async => (await _storage.read(key: _key)) != null;

  Future<void> clear() async => _storage.delete(key: _key);

  /// Renueva el access token con el refresh guardado y devuelve el AuthToken.
  /// null si no hay sesión o el refresh expiró (→ hay que loguearse de nuevo).
  Future<AuthToken?> restore() async {
    final raw = await _storage.read(key: _key);
    if (raw == null) return null;

    final data = jsonDecode(raw) as Map<String, dynamic>;
    final refresh = data['refresh'] as String;

    try {
      final response = await HttpClient.instance.post('/auth/refresh/mobile', {
        'refresh_token': refresh,
      });
      if (response.statusCode < 200 || response.statusCode >= 300) {
        await clear(); // refresh expirado/ inválido
        return null;
      }
      final access =
          (jsonDecode(response.body) as Map<String, dynamic>)['access_token']
              as String;

      final userId = data['userId'] as int;
      HttpClient.instance.setTokens(
        access: access,
        refresh: refresh,
        userId: userId,
      );

      return AuthToken(
        token: access,
        userId: userId,
        name: data['name'] as String,
        lastName: data['lastName'] as String,
        email: data['email'] as String,
        role: data['role'] as String,
        profileImage: data['profileImage'] as String?,
        oauthProvider: data['oauthProvider'] as String,
      );
    } catch (_) {
      return null; // sin conexión: no borres la sesión, reintenta luego
    }
  }
}
