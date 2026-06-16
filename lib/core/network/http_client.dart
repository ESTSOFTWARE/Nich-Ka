import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpClient {
  HttpClient._();
  static final HttpClient instance = HttpClient._();

  //static const String _baseUrl = 'https://backend.nich-ka.space/api';
  static const String _baseUrl = 'http://localhost:8000/api';

  final http.Client _client = http.Client();
  String? _accessToken;

  void setTokens({required String access, required String refresh}) {
    _accessToken = access;
  }

  void clearTokens() {
    _accessToken = null;
  }

  bool get hasToken => _accessToken != null;

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

  Future<http.Response> delete(String path) =>
      _client.delete(Uri.parse('$_baseUrl$path'), headers: _headers());

  void close() => _client.close();
}
