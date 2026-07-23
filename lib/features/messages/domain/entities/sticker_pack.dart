import 'sticker_item.dart';

export 'sticker_item.dart';

class StickerPack {
  final String identifier;
  final String name;
  final String trayImage;
  final List<StickerItem> stickers;

  const StickerPack({
    required this.identifier,
    required this.name,
    required this.trayImage,
    required this.stickers,
  });
}
