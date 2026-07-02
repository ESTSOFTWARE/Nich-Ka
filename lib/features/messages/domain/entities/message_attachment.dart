class MessageAttachment {
  final int id;
  final String type; // image | video | document | file
  final String name;
  final String url;
  final int size;

  const MessageAttachment({
    required this.id,
    required this.type,
    required this.name,
    required this.url,
    this.size = 0,
  });

  bool get isImage => type == 'image';
  bool get isVideo => type == 'video';

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'name': name,
    'url': url,
    'size': size,
  };
}
