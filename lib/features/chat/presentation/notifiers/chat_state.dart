import '../../domain/entities/chat_message.dart';

class ChatState {
  final bool isScrolled;
  final bool isLoading;
  final String? error;
  final List<ChatMessage> messages;

  const ChatState({
    this.isScrolled = false,
    this.isLoading = false,
    this.error,
    this.messages = const [],
  });

  static const Object _keep = Object();

  ChatState copyWith({
    bool? isScrolled,
    bool? isLoading,
    Object? error = _keep,
    List<ChatMessage>? messages,
  }) => ChatState(
    isScrolled: isScrolled ?? this.isScrolled,
    isLoading: isLoading ?? this.isLoading,
    error: identical(error, _keep) ? this.error : error as String?,
    messages: messages ?? this.messages,
  );
}
