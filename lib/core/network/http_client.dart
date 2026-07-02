import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpClient {
  HttpClient._();
  static final HttpClient instance = HttpClient._();

  static const String _baseUrl = String.fromEnvironment('BASE_URL');

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

  int get userId => _userId;

  String? get accessToken => _accessToken;

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
