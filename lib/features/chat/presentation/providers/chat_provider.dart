import 'package:flutter/material.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_message_type.dart';

class ChatProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();

  final List<ChatMessage> messages = const [
    ChatMessage(
      text:
          'Hola Ameth. Detecté que la fermentación F-024 entró en fase pico hace 14 minutos.',
      type: ChatMessageType.ai,
      time: '16:38',
      highlightId: 'F-024',
    ),
    ChatMessage(
      text: '¿Eso es bueno?',
      type: ChatMessageType.user,
      time: '16:39',
    ),
    ChatMessage(
      text:
          'Sí — la actividad microbiana está en su máximo. Tu densidad bajó de 1.064 → 1.024 a un ritmo saludable.',
      type: ChatMessageType.ai,
      time: '16:39',
    ),
    ChatMessage(
      text:
          'Recomendación: reducir 1.5 °C en las próximas 2 h para perfil floral.',
      type: ChatMessageType.recommendation,
      time: '16:40',
    ),
    ChatMessage(
      text: '¿Y si quiero notas más afrutadas?',
      type: ChatMessageType.user,
      time: '16:41',
    ),
    ChatMessage(
      text:
          'Mantén la temperatura actual y extiende 4 h más. Ajusto la predicción a perfil afrutado-cítrico.',
      type: ChatMessageType.ai,
      time: '16:41',
    ),
  ];

  final List<String> suggestions = const [
    'Comparar F-023',
    'Predicción de sabor',
    '¿Cuándo termina?',
  ];

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
