class SendMessageRequestDto {
  final String? content;
  final List<Map<String, dynamic>> attachments;
  final int? replyToId;

  const SendMessageRequestDto({
    this.content,
    this.attachments = const [],
    this.replyToId,
  });

  Map<String, dynamic> toJson() => {
        if (content != null) 'content': content,
        'attachments': attachments,
        if (replyToId != null) 'replyToId': replyToId,
      };
}
