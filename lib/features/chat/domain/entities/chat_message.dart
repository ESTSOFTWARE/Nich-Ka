import 'chat_message_type.dart';

class ChatMessage {
  final String text;
  final ChatMessageType type;
  final String time;
  final String? highlightId;

  const ChatMessage({
    required this.text,
    required this.type,
    required this.time,
    this.highlightId,
  });
}
