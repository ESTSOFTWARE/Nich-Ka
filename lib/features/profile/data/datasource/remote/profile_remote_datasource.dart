import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../core/network/http_client.dart';
import 'model/dto/response/user_profile_dto.dart';

class ProfileRemoteDataSource {
  final HttpClient _client;

  const ProfileRemoteDataSource(this._client);

  Future<UserProfileDto> getCurrentUser() async {
    final response = await _client.get('/users/me');
    _assertSuccess(response, 'No se pudo obtener la información del perfil.');
    return UserProfileDto.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
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
