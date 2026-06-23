class EditMessageRequestDto {
  final String content;

  const EditMessageRequestDto({required this.content});

  Map<String, dynamic> toJson() => {'content': content};
}
