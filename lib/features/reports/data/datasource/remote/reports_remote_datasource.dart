import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../core/network/http_client.dart';
import 'model/dto/response/fermentation_report_response_dto.dart';
import 'model/dto/response/fermentation_session_response_dto.dart';
import 'model/dto/response/report_history_response_dto.dart';

class ReportsRemoteDataSource {
  final HttpClient _client;

  const ReportsRemoteDataSource(this._client);

  /// Una sola petición que devuelve sesiones + reporte (o null) juntos.
  /// El backend resuelve el join en BD; evita el N+1 del enfoque anterior.
  Future<List<(FermentationSessionResponseDto, FermentationReportResponseDto?)>>
  getSessionsWithReports() async {
    final response = await _client.get('/fermentation/sessions-with-reports');
    _assertSuccess(response, 'No se pudieron obtener las sesiones.');
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) {
      final map = e as Map<String, dynamic>;
      final session = FermentationSessionResponseDto.fromJson(
        map['session'] as Map<String, dynamic>,
      );
      final reportJson = map['report'] as Map<String, dynamic>?;
      final report = reportJson != null
          ? FermentationReportResponseDto.fromJson(reportJson)
          : null;
      return (session, report);
    }).toList();
  }

  Future<List<FermentationSessionResponseDto>> getSessions() async {
    final response = await _client.get('/fermentation/sessions');
    _assertSuccess(response, 'No se pudieron obtener las sesiones.');
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map(
          (e) => FermentationSessionResponseDto.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<FermentationSessionResponseDto> getSession(int sessionId) async {
    final sessions = await getSessions();
    final match = sessions.cast<FermentationSessionResponseDto?>().firstWhere(
      (s) => s!.id == sessionId,
      orElse: () => null,
    );
    if (match == null) throw Exception('Sesión $sessionId no encontrada.');
    return match;
  }

  Future<FermentationReportResponseDto?> getReport(int sessionId) async {
    final response = await _client.get('/fermentation/$sessionId/report');
    if (response.statusCode >= 400) return null;
    _assertSuccess(response, 'No se pudo obtener el reporte.');
    return FermentationReportResponseDto.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<List<ReportHistoryResponseDto>> getHistory() async {
    final response = await _client.get('/fermentation/history');
    _assertSuccess(response, 'No se pudo obtener el historial.');
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map(
          (e) => ReportHistoryResponseDto.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  Future<List<int>> downloadPdf(int sessionId) async {
    final response = await _client.get('/fermentation/$sessionId/report/pdf');
    _assertSuccess(response, 'No se pudo descargar el PDF.');
    return response.bodyBytes.toList();
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
