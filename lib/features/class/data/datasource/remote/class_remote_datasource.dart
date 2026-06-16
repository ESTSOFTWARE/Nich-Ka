import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../core/network/http_client.dart';
import '../../../domain/entities/class_detail.dart';
import 'mapper/class_mapper.dart';
import 'model/dto/request/join_class_request_dto.dart';
import 'model/dto/response/group_response_dto.dart';

class ClassRemoteDataSource {
  final HttpClient _client;

  const ClassRemoteDataSource(this._client);

  Future<List<ClassDetail>> getClasses() async {
    final response = await _client.get('/groups/me');
    _assertSuccess(response, 'No se pudieron cargar las clases.');
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map(
          (e) => ClassMapper.toDetail(
            GroupResponseDto.fromJson(e as Map<String, dynamic>),
          ),
        )
        .toList();
  }

  Future<void> joinClass(String code) async {
    final dto = JoinClassRequestDto(code: code.trim().toUpperCase());
    final response = await _client.post('/groups/join', dto.toJson());
    _assertSuccess(response, 'No se pudo unir a la clase.');
  }

  void _assertSuccess(http.Response response, String fallbackMessage) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      String message = fallbackMessage;
      try {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final detail = body['detail'];
        if (detail is String) message = detail;
      } catch (_) {}
      throw Exception(message);
    }
  }
}
