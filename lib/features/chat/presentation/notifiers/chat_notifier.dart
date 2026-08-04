import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/groq_api_service.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_message_type.dart';
import 'chat_state.dart';

class ChatNotifier extends Notifier<ChatState> {
  final ScrollController scrollController = ScrollController();
  final GroqApiService _api = GroqApiService();

  /// Sugerencias fijas (no cambian con el estado).
  static const List<String> suggestions = [
    'Comparar F-023',
    'Predicción de sabor',
    '¿Cuándo termina?',
  ];

  @override
  ChatState build() {
    scrollController.addListener(_onScroll);
    ref.onDispose(() {
      scrollController.removeListener(_onScroll);
      scrollController.dispose();
    });
    return const ChatState();
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != state.isScrolled) {
      state = state.copyWith(isScrolled: scrolled);
    }
  }

  String _now() {
    final t = DateTime.now();
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isLoading) return;

    state = state.copyWith(
      error: null,
      isLoading: true,
      messages: [
        ...state.messages,
        ChatMessage(text: trimmed, type: ChatMessageType.user, time: _now()),
      ],
    );
    _scrollToBottom();

    try {
      final reply = await _api.send(trimmed);
      state = state.copyWith(
        messages: [
          ...state.messages,
          ChatMessage(text: reply, type: ChatMessageType.ai, time: _now()),
        ],
        isLoading: false,
      );
    } on Exception catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      state = state.copyWith(
        error: msg == 'rate_limit'
            ? 'Demasiadas solicitudes. Espera un momento.'
            : 'No se pudo conectar con el asistente.',
        isLoading: false,
      );
    } finally {
      _scrollToBottom();
    }
  }

  void clearError() => state = state.copyWith(error: null);

  void clearChat() {
    _api.clearHistory();
    state = state.copyWith(messages: [], error: null);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}

final chatProvider = NotifierProvider<ChatNotifier, ChatState>(
  ChatNotifier.new,
);
