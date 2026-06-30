import 'dart:convert';

import '../../../../../core/network/http_client.dart';
import 'mapper/fermentation_batch_mapper.dart';
import 'model/dto/fermentation_batch_dto.dart';
import 'model/fermentation_batch_model.dart';

class FermentationBatchesDatasource {
  final HttpClient _client;

  const FermentationBatchesDatasource(this._client);

  Future<List<FermentationBatchModel>> fetchBatches() async {
    final response = await _client.get('/fermentation/sessions');
    if (response.statusCode < 200 || response.statusCode >= 300) {
      return [];
    }
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => FermentationBatchDto.fromJson(e as Map<String, dynamic>))
        .map(FermentationBatchMapper.fromDto)
        .toList();
  }
}
