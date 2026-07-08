import '../../../core/network/http_client.dart';
import '../../../core/router/app_router.dart';
import '../data/datasource/remote/chat_remote_datasource.dart';
import '../data/datasource/remote/mapper/chat_mapper.dart';

/// Abre el chat de una conversación desde un push (mensaje o mención) y, si se
/// indica, salta al mensaje mencionado. Trae la conversación por id porque el
/// push solo lleva el id, no el objeto completo.
Future<void> openChatFromPush(int conversationId, {int? messageId}) async {
  try {
    final ds = ChatRemoteDataSource(HttpClient.instance);
    final dto = await ds.getConversationDetail(conversationId);
    final conv = ChatMapper.fromConversationDto(dto);
    final path = messageId != null
        ? '/group-chat?highlight=$messageId'
        : '/group-chat';
    appRouter.push(path, extra: conv);
  } catch (_) {}
}
