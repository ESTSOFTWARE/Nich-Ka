import 'dart:convert';
import '../../../../../core/network/http_client.dart';
import '../../../domain/entities/sticker_pack.dart';

class StickerRemoteDataSource {
  final HttpClient _client;

  const StickerRemoteDataSource(this._client);

  Future<List<StickerPack>> getPacks() async {
    final response = await _client.get('/stickers/packs');
    if (response.statusCode < 200 || response.statusCode >= 300) {
      return [];
    }
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((json) => _fromPackJson(json as Map<String, dynamic>))
        .toList();
  }

  StickerPack _fromPackJson(Map<String, dynamic> json) {
    final stickers = (json['stickers'] as List<dynamic>? ?? []).map((s) {
      return StickerItem(
        assetPath: s['asset_url'] as String? ?? '',
        emojis: (s['emojis'] as List<dynamic>? ?? []).cast<String>(),
      );
    }).toList();

    return StickerPack(
      identifier: json['identifier'] as String? ?? '',
      name: json['name'] as String? ?? '',
      trayImage: json['tray_image'] as String? ?? '',
      stickers: stickers,
    );
  }
}
