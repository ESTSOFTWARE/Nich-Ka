class SendMessageRequestDto {
  final String? content;
  final List<Map<String, dynamic>> attachments;
  final int? replyToId;
  final List<int> mentions;

  const SendMessageRequestDto({
    this.content,
    this.attachments = const [],
    this.replyToId,
    this.mentions = const [],
  });

  Map<String, dynamic> toJson() => {
    if (content != null) 'content': content,
    'attachments': attachments,
    if (replyToId != null) 'replyToId': replyToId,
    if (mentions.isNotEmpty) 'mentions': mentions,
  };
}
