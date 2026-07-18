import '../../../core/network/http_client.dart';
import '../../../core/router/app_router.dart';
import '../data/datasource/remote/chat_remote_datasource.dart';
import '../data/datasource/remote/mapper/chat_mapper.dart';

Future<void> openChatFromPush(int conversationId, {int? messageId}) async {
  try {
    for (var i = 0; i < 40 && !HttpClient.instance.hasToken; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
    }
    if (!HttpClient.instance.hasToken) return;

    final ds = ChatRemoteDataSource(HttpClient.instance);
    final dto = await ds.getConversationDetail(conversationId);
    final conv = ChatMapper.fromConversationDto(dto);
    final path = messageId != null
        ? '/group-chat?highlight=$messageId'
        : '/group-chat';
    appRouter.push(path, extra: conv);
  } catch (_) {}
}
