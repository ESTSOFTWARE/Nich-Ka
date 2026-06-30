import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpClient {
  HttpClient._();
  static final HttpClient instance = HttpClient._();

  // arreglar esto para que se use la variable de entorno del .env
  // static const _apiUrl = String.fromEnvironment('BASE_URL', defaultValue: '');
  //static const String _baseUrl = 'https://backend.nich-ka.space/api';
  static const String _baseUrl = 'https://api.nich-ka.space/api';
  // Local en celular físico (misma WiFi): IP LAN de la PC. Backend debe correr en --host 0.0.0.0.
  // Emulador Android sería http://10.0.2.2:8000/api ; producción, los dominios de arriba.
  // static const String _baseUrl = 'http://localhost:8000/api'; // descomenten para probar en local y asugurense que el backend se corra con los parametros --host 0.0.0.0 si no, no va a funcionar

  final http.Client _client = http.Client();
  String? _accessToken;
  int _userId = 0;

  void setTokens({
    required String access,
    required String refresh,
    int userId = 0,
  }) {
    _accessToken = access;
    _userId = userId;
  }

  void clearTokens() {
    _accessToken = null;
    _userId = 0;
  }

  bool get hasToken => _accessToken != null;

  /// ID del usuario en sesión. Lo usan componentes que necesitan identificar
  /// mensajes propios sin pasar el ID como parámetro por toda la cadena.
  int get userId => _userId;

  /// Token de acceso actual (JWT). Para abrir WebSockets que se autentican por
  /// cookie `access_token` en el handshake.
  String? get accessToken => _accessToken;

  /// Base WebSocket derivada del API (https→wss, sin el sufijo `/api`).
  /// Ej: https://api.nich-ka.space/api → wss://api.nich-ka.space
  static String get wsBaseUrl => _baseUrl
      .replaceFirst(RegExp(r'^http'), 'ws')
      .replaceFirst(RegExp(r'/api/?$'), '');

  Map<String, String> _headers() => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
  };

  Future<http.Response> get(String path) =>
      _client.get(Uri.parse('$_baseUrl$path'), headers: _headers());

  Future<http.Response> post(String path, Map<String, dynamic> body) =>
      _client.post(
        Uri.parse('$_baseUrl$path'),
        headers: _headers(),
        body: jsonEncode(body),
      );

  Future<http.Response> put(String path, Map<String, dynamic> body) =>
      _client.put(
        Uri.parse('$_baseUrl$path'),
        headers: _headers(),
        body: jsonEncode(body),
      );

  Future<http.Response> patch(String path, Map<String, dynamic> body) =>
      _client.patch(
        Uri.parse('$_baseUrl$path'),
        headers: _headers(),
        body: jsonEncode(body),
      );

  Future<http.Response> delete(String path) =>
      _client.delete(Uri.parse('$_baseUrl$path'), headers: _headers());

  Future<http.Response> postMultipart(
    String path,
    List<http.MultipartFile> files,
  ) async {
    final request = http.MultipartRequest('POST', Uri.parse('$_baseUrl$path'));
    if (_accessToken != null) {
      request.headers['Authorization'] = 'Bearer $_accessToken';
    }
    request.files.addAll(files);
    final streamed = await request.send();
    return http.Response.fromStream(streamed);
  }

  void close() => _client.close();
}
