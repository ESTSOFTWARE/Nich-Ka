class StickerItem {
  final String assetPath;
  final List<String> emojis;

  const StickerItem({required this.assetPath, this.emojis = const []});
}

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
