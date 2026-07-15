import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
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

  Future<UserProfileDto> getUserById(int userId) async {
    final response = await _client.get('/users/$userId');
    _assertSuccess(response, 'No se pudo obtener la información del usuario.');
    return UserProfileDto.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<UserProfileDto> updateProfile({
    String? name,
    String? lastName,
    String? dialCode,
    String? phoneNumber,
    String? description,
  }) async {
    final response = await _client.put('/users/${_client.userId}', {
      'name': ?name,
      'last_name': ?lastName,
      'dial_code': ?dialCode,
      'phone_number': ?phoneNumber,
      'description': ?description,
    });
    _assertSuccess(response, 'No se pudo actualizar el perfil.');
    // El PUT devuelve el usuario en formato admin; releemos /users/me para
    // tener el perfil completo y consistente.
    return getCurrentUser();
  }

  Future<String> uploadProfileImage(File file) async {
    // El backend solo acepta jpeg/png/webp/svg; hay que declarar el content-type
    // (si no, Dart manda application/octet-stream y lo rechaza).
    final ext = file.path.split('.').last.toLowerCase();
    final subtype = switch (ext) {
      'png' => 'png',
      'webp' => 'webp',
      'svg' => 'svg+xml',
      _ => 'jpeg',
    };
    final multipart = await http.MultipartFile.fromPath(
      'file',
      file.path,
      contentType: MediaType('image', subtype),
    );
    final response = await _client.postMultipart('/users/me/profile-image', [
      multipart,
    ]);
    _assertSuccess(response, 'No se pudo subir la imagen.');
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return json['profile_image'] as String;
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
