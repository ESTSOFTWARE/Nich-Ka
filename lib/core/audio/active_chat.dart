/// ID de la conversación abierta actualmente. Sirve para no reproducir
/// `sound_message` (lista) cuando ya estás dentro del chat (que suena
/// `sound_response_message`), y para no mostrar push del chat activo.
class ActiveChat {
  ActiveChat._();
  static int? conversationId;
}
