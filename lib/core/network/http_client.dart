import 'dart:convert';
import 'dart:io' show HandshakeException, CertificateException;

import 'package:http/http.dart' as http;

import 'certificate_pinning.dart';

class HttpClient {
  HttpClient._();
  static final HttpClient instance = HttpClient._();

  static const String _baseUrl = String.fromEnvironment('BASE_URL');

  http.Client? _client;
  String? _accessToken;
  String? _refreshToken;
  int _userId = 0;

  Future<void> initialize() async {
    _client ??= await PinnedClientFactory.client;
  }

  Future<http.Client> _ensureClient() async =>
      _client ??= await PinnedClientFactory.client;

  void setTokens({
    required String access,
    required String refresh,
    int userId = 0,
  }) {
    _accessToken = access;
    _refreshToken = refresh;
    _userId = userId;
  }

  void setAccessToken(String access) {
    _accessToken = access;
  }

  void clearTokens() {
    _accessToken = null;
    _refreshToken = null;
    _userId = 0;
  }

  bool get hasToken => _accessToken != null;

  int get userId => _userId;

  String? get accessToken => _accessToken;

  String? get refreshToken => _refreshToken;

  static String get wsBaseUrl => _baseUrl
      .replaceFirst(RegExp(r'^http'), 'ws')
      .replaceFirst(RegExp(r'/api/?$'), '');

  Map<String, String> _headers() => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
  };

  Future<T> _guarded<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on HandshakeException {
      throw const CertificatePinningException();
    } on CertificateException {
      throw const CertificatePinningException();
    }
  }

  Future<http.Response> get(String path) => _guarded(() async {
    final client = await _ensureClient();
    return client.get(Uri.parse('$_baseUrl$path'), headers: _headers());
  });

  Future<http.Response> post(String path, Map<String, dynamic> body) =>
      _guarded(() async {
        final client = await _ensureClient();
        return client.post(
          Uri.parse('$_baseUrl$path'),
          headers: _headers(),
          body: jsonEncode(body),
        );
      });

  Future<http.Response> put(String path, Map<String, dynamic> body) =>
      _guarded(() async {
        final client = await _ensureClient();
        return client.put(
          Uri.parse('$_baseUrl$path'),
          headers: _headers(),
          body: jsonEncode(body),
        );
      });

  Future<http.Response> patch(String path, Map<String, dynamic> body) =>
      _guarded(() async {
        final client = await _ensureClient();
        return client.patch(
          Uri.parse('$_baseUrl$path'),
          headers: _headers(),
          body: jsonEncode(body),
        );
      });

  Future<http.Response> delete(String path) => _guarded(() async {
    final client = await _ensureClient();
    return client.delete(Uri.parse('$_baseUrl$path'), headers: _headers());
  });

  Future<http.Response> postMultipart(
    String path,
    List<http.MultipartFile> files,
  ) => _guarded(() async {
    final client = await _ensureClient();
    final request = http.MultipartRequest('POST', Uri.parse('$_baseUrl$path'));
    if (_accessToken != null) {
      request.headers['Authorization'] = 'Bearer $_accessToken';
    }
    request.files.addAll(files);
    final streamed = await client.send(request);
    return http.Response.fromStream(streamed);
  });

  void close() => _client?.close();
}
