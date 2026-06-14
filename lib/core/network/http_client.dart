import 'package:http/http.dart' as http;

class HttpClient {
  HttpClient._();
  static final HttpClient instance = HttpClient._();

  static const String _baseUrl = 'https://api.tudominio.com/v1';

  final http.Client _client = http.Client();

  Map<String, String> _headers({String? token}) => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  Future<http.Response> get(String path, {String? token}) {
    return _client.get(
      Uri.parse('$_baseUrl$path'),
      headers: _headers(token: token),
    );
  }

  Future<http.Response> post(
    String path,
    Map<String, dynamic> body, {
    String? token,
  }) {
    return _client.post(
      Uri.parse('$_baseUrl$path'),
      headers: _headers(token: token),
      body: body.toString(),
    );
  }

  Future<http.Response> put(
    String path,
    Map<String, dynamic> body, {
    String? token,
  }) {
    return _client.put(
      Uri.parse('$_baseUrl$path'),
      headers: _headers(token: token),
      body: body.toString(),
    );
  }

  Future<http.Response> delete(String path, {String? token}) {
    return _client.delete(
      Uri.parse('$_baseUrl$path'),
      headers: _headers(token: token),
    );
  }

  void close() => _client.close();
}
