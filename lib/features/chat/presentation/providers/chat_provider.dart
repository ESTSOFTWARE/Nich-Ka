import 'package:flutter/material.dart';
import '../../data/groq_api_service.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_message_type.dart';

class ChatProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  final GroqApiService _api = GroqApiService();

  bool _isScrolled = false;
  bool get isScrolled => _isScrolled;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  final List<ChatMessage> messages = [];

  final List<String> suggestions = const [
    'Comparar F-023',
    'Predicción de sabor',
    '¿Cuándo termina?',
  ];

  ChatProvider() {
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != _isScrolled) {
      _isScrolled = scrolled;
      notifyListeners();
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
    if (trimmed.isEmpty || _isLoading) return;

    _error = null;
    messages.add(ChatMessage(text: trimmed, type: ChatMessageType.user, time: _now()));
    _isLoading = true;
    notifyListeners();
    _scrollToBottom();

    try {
      final reply = await _api.send(trimmed);
      messages.add(ChatMessage(text: reply, type: ChatMessageType.ai, time: _now()));
    } on Exception catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      if (msg == 'rate_limit') {
        _error = 'Demasiadas solicitudes. Espera un momento.';
      } else {
        _error = 'No se pudo conectar con el asistente.';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
      _scrollToBottom();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearChat() {
    messages.clear();
    _api.clearHistory();
    _error = null;
    notifyListeners();
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

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }
}
