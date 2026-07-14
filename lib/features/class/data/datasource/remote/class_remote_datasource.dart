import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../core/network/http_client.dart';
import '../../../domain/entities/class_detail.dart';
import '../../../domain/entities/class_fermentation.dart';
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

  Future<List<ClassFermentation>> getGroupSessions(int groupId) async {
    final response = await _client.get('/fermentation/sessions');
    if (response.statusCode >= 400) return [];
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => e as Map<String, dynamic>)
        .where((m) => m['group_id'] == groupId)
        .map((m) {
          final sessionId = m['id'] as int;
          final status = (m['status'] as String?) ?? '';
          final start = (m['scheduled_start'] ?? '').toString();
          return ClassFermentation(
            id: 'F-${sessionId.toString().padLeft(3, '0')}',
            variety: 'Sesión #$sessionId',
            process: _formatShortDate(start),
            isActive: status == 'active',
          );
        })
        .toList();
  }

  Future<void> joinClass(String code) async {
    final dto = JoinClassRequestDto(code: code.trim().toUpperCase());
    final response = await _client.post('/groups/join', dto.toJson());
    _assertSuccess(response, 'No se pudo unir a la clase.');
  }

  String _formatShortDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      const months = [
        'ene', 'feb', 'mar', 'abr', 'may', 'jun',
        'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
      ];
      return '${dt.day} ${months[dt.month - 1]}';
    } catch (_) {
      return iso;
    }
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
