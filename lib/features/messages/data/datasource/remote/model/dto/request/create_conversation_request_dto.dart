class CreateConversationRequestDto {
  final String type;
  final List<int> memberIds;
  final String? name;

  const CreateConversationRequestDto({
    required this.type,
    required this.memberIds,
    this.name,
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'memberIds': memberIds,
    if (name != null) 'name': name,
  };
}
