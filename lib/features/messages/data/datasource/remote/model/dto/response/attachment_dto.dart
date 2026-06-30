class AttachmentDto {
  final int id;
  final String type;
  final String name;
  final String url;
  final int size;

  const AttachmentDto({
    required this.id,
    required this.type,
    required this.name,
    required this.url,
    this.size = 0,
  });

  factory AttachmentDto.fromJson(Map<String, dynamic> json) => AttachmentDto(
    id: json['id'] as int,
    type: json['type'] as String,
    name: json['name'] as String,
    url: json['url'] as String,
    size: (json['size'] as num?)?.toInt() ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'name': name,
    'url': url,
    'size': size,
  };
}
