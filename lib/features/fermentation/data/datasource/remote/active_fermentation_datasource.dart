import 'dart:convert';

import '../../../../../core/network/http_client.dart';
import '../../../../reports/data/datasource/remote/model/dto/response/fermentation_session_response_dto.dart';

/// Consulta la sesión de fermentación activa del circuito del usuario.
/// El backend responde 200 con `null` cuando no hay ninguna activa.
class ActiveFermentationDatasource {
  final HttpClient _client;

  const ActiveFermentationDatasource(this._client);

  Future<FermentationSessionResponseDto?> fetchActive() async {
    final response = await _client.get('/fermentation/active');
    if (response.statusCode < 200 || response.statusCode >= 300) return null;

    final body = response.body.trim();
    if (body.isEmpty || body == 'null') return null;

    final json = jsonDecode(body);
    if (json == null) return null;

    return FermentationSessionResponseDto.fromJson(
      json as Map<String, dynamic>,
    );
  }
}
