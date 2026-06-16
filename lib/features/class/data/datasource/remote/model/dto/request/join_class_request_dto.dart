class JoinClassRequestDto {
  final String code;

  const JoinClassRequestDto({required this.code});

  Map<String, dynamic> toJson() => {'code': code};
}
