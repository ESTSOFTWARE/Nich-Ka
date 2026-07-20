import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/chat_dependencies.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_message_type.dart';
import '../states/chat_state.dart';

class ChatNotifier extends Notifier<ChatState> {
  late final ScrollController scrollController;
  late final _api = ChatDependencies.groqApi;

  @override
  ChatState build() {
    scrollController = ScrollController();
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

    final userMessage = ChatMessage(
      text: trimmed,
      type: ChatMessageType.user,
      time: _now(),
    );
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: () => null,
    );
    _scrollToBottom();

    try {
      final reply = await _api.send(trimmed);
      final aiMessage = ChatMessage(
        text: reply,
        type: ChatMessageType.ai,
        time: _now(),
      );
      state = state.copyWith(messages: [...state.messages, aiMessage]);
    } on Exception catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      if (msg == 'rate_limit') {
        state = state.copyWith(
          error: () => 'Demasiadas solicitudes. Espera un momento.',
        );
      } else {
        state = state.copyWith(
          error: () => 'No se pudo conectar con el asistente.',
        );
      }
    } finally {
      state = state.copyWith(isLoading: false);
      _scrollToBottom();
    }
  }

  void clearError() {
    state = state.copyWith(error: () => null);
  }

  void clearChat() {
    _api.clearHistory();
    state = const ChatState();
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
