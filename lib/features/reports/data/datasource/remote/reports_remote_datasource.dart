import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../core/network/http_client.dart';
import 'model/dto/response/fermentation_report_response_dto.dart';
import 'model/dto/response/fermentation_session_response_dto.dart';

class ReportsRemoteDataSource {
  final HttpClient _client;

  const ReportsRemoteDataSource(this._client);

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

  Future<FermentationReportResponseDto?> getReport(int sessionId) async {
    final response = await _client.get('/fermentation/$sessionId/report');
    if (response.statusCode == 404) return null;
    _assertSuccess(response, 'No se pudo obtener el reporte.');
    return FermentationReportResponseDto.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
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
