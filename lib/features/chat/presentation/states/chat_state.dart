import '../../domain/entities/chat_message.dart';

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;
  final bool isScrolled;
  final List<String> suggestions;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
    this.isScrolled = false,
    this.suggestions = const [
      'Comparar F-023',
      'Predicción de sabor',
      '¿Cuándo termina?',
    ],
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? Function()? error,
    bool? isScrolled,
    List<String>? suggestions,
  }) => ChatState(
    messages: messages ?? this.messages,
    isLoading: isLoading ?? this.isLoading,
    error: error != null ? error() : this.error,
    isScrolled: isScrolled ?? this.isScrolled,
    suggestions: suggestions ?? this.suggestions,
  );
}
