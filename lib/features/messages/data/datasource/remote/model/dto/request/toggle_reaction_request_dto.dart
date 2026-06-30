class ToggleReactionRequestDto {
  final String emoji;

  const ToggleReactionRequestDto({required this.emoji});

  Map<String, dynamic> toJson() => {'emoji': emoji};
}
