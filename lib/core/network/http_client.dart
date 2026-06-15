import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpClient {
  HttpClient._();
  static final HttpClient instance = HttpClient._();

  static const String _baseUrl = 'http://localhost:8000/api';

  final http.Client _client = http.Client();
  String? _accessToken;
  String? _refreshToken;

  void setTokens({required String access, required String refresh}) {
    _accessToken = access;
    _refreshToken = refresh;
  }

  void clearTokens() {
    _accessToken = null;
    _refreshToken = null;
  }

  bool get hasToken => _accessToken != null;

  Map<String, String> _headers() {
    final cookies = [
      if (_accessToken != null) 'access_token=$_accessToken',
      if (_refreshToken != null) 'refresh_token=$_refreshToken',
    ];
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (cookies.isNotEmpty) 'Cookie': cookies.join('; '),
    };
  }

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
