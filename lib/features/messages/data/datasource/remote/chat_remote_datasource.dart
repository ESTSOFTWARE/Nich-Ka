import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../../../core/network/http_client.dart';
import 'model/dto/request/create_conversation_request_dto.dart';
import 'model/dto/request/edit_message_request_dto.dart';
import 'model/dto/request/send_message_request_dto.dart';
import 'model/dto/request/toggle_reaction_request_dto.dart';
import 'model/dto/response/attachment_dto.dart';
import 'model/dto/response/conversation_dto.dart';
import 'model/dto/response/member_dto.dart';
import 'model/dto/response/message_dto.dart';

class ChatRemoteDataSource {
  final HttpClient _client;

  const ChatRemoteDataSource(this._client);

  // ── Conversations ────────────────────────────────────────────────────────────

  Future<List<MemberDto>> getContacts() async {
    final res = await _client.get('/chat/contacts');
    _assertOk(res, 'No se pudieron cargar los contactos.');
    final list = jsonDecode(res.body) as List<dynamic>;
    return list
        .map((e) => MemberDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ConversationDto> createConversation(
      CreateConversationRequestDto request) async {
    final res = await _client.post('/chat/conversations', request.toJson());
    _assertOk(res, 'No se pudo crear la conversación.');
    return ConversationDto.fromJson(
        jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<List<ConversationDto>> getConversations() async {
    final res = await _client.get('/chat/conversations');
    _assertOk(res, 'No se pudieron cargar las conversaciones.');
    final list = jsonDecode(res.body) as List<dynamic>;
    return list
        .map((e) => ConversationDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> markRead(int conversationId) async {
    await _client.post('/chat/conversations/$conversationId/read', {});
  }

  Future<void> leaveConversation(int conversationId) async {
    final res = await _client.delete('/chat/conversations/$conversationId/leave');
    _assertOk(res, 'No se pudo salir de la conversación.');
  }

  Future<void> updateConversation(int conversationId,
      {String? name, String? description}) async {
    final body = <String, dynamic>{
      'name': name,
      'description': description,
    }..removeWhere((_, v) => v == null);
    final res = await _client.patch('/chat/conversations/$conversationId', body);
    _assertOk(res, 'No se pudo actualizar la conversación.');
  }

  // ── Messages ─────────────────────────────────────────────────────────────────

  Future<List<MessageDto>> getMessages(
    int conversationId, {
    int? cursor,
    int limit = 40,
  }) async {
    final query =
        cursor != null ? '?cursor=$cursor&limit=$limit' : '?limit=$limit';
    final res =
        await _client.get('/chat/conversations/$conversationId/messages$query');
    _assertOk(res, 'No se pudieron cargar los mensajes.');
    final list = jsonDecode(res.body) as List<dynamic>;
    return list
        .map((e) => MessageDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<MessageDto> sendMessage(
    int conversationId,
    SendMessageRequestDto request,
  ) async {
    final res = await _client.post(
      '/chat/conversations/$conversationId/messages',
      request.toJson(),
    );
    _assertOk(res, 'No se pudo enviar el mensaje.');
    return MessageDto.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<MessageDto> editMessage(
    int messageId,
    EditMessageRequestDto request,
  ) async {
    final res =
        await _client.patch('/chat/messages/$messageId', request.toJson());
    _assertOk(res, 'No se pudo editar el mensaje.');
    return MessageDto.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<void> deleteMessage(int messageId) async {
    final res = await _client.delete('/chat/messages/$messageId');
    _assertOk(res, 'No se pudo eliminar el mensaje.');
  }

  Future<bool> pinMessage(int messageId) async {
    final res = await _client.post('/chat/messages/$messageId/pin', {});
    _assertOk(res, 'No se pudo fijar el mensaje.');
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return body['pinned'] as bool? ?? false;
  }

  Future<void> setPriority(int messageId, String priority) async {
    final res = await _client
        .patch('/chat/messages/$messageId/priority', {'priority': priority});
    _assertOk(res, 'No se pudo cambiar la prioridad.');
  }

  Future<MessageDto> toggleReaction(
    int messageId,
    ToggleReactionRequestDto request,
  ) async {
    final res = await _client.post(
        '/chat/messages/$messageId/reactions', request.toJson());
    _assertOk(res, 'No se pudo reaccionar al mensaje.');
    return MessageDto.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<AttachmentDto> uploadFile(File file) async {
    final multipart = await http.MultipartFile.fromPath('file', file.path);
    final res = await _client.postMultipart('/chat/uploads', [multipart]);
    _assertOk(res, 'No se pudo subir el archivo.');
    return AttachmentDto.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  // ── WebSocket ────────────────────────────────────────────────────────────────

  WebSocketChannel connectChat() {
    final token = _client.accessToken;
    final uri = Uri.parse(
      '${HttpClient.wsBaseUrl}/ws/chat${token != null ? '?token=$token' : ''}',
    );
    return WebSocketChannel.connect(uri);
  }

  void sendTyping(WebSocketChannel channel, int conversationId, bool typing) {
    channel.sink.add(jsonEncode({
      'type': typing ? 'typing:start' : 'typing:stop',
      'conversationId': conversationId,
    }));
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  void _assertOk(http.Response res, String fallback) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      try {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final detail = body['detail'];
        throw Exception(detail is String ? detail : fallback);
      } catch (_) {
        throw Exception(fallback);
      }
    }
  }
}
