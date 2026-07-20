import 'dart:async';
import 'dart:convert';

import '../../../../../core/network/http_client.dart';
import '../../../domain/entities/connection_state.dart';
import '../../services/notification_websocket_service.dart';
import 'mapper/notification_mapper.dart';
import 'model/dto/notification_dto.dart';
import 'model/notification_model.dart';

class NotificationDatasource {
  final HttpClient _client;
  final NotificationWebSocketService _wsService;

  NotificationDatasource(this._client)
    : _wsService = NotificationWebSocketService.instance;

  Stream<NotificationModel> get onNotificationReceived {
    return _wsService.events.map(NotificationMapper.fromEventDto);
  }

  Stream<NotificationConnectionState> get connectionState {
    return _wsService.connectionState;
  }

  void connectWebSocket({required int userId, String? token}) {
    _wsService.connect(userId: userId, token: token);
  }

  void disconnectWebSocket() {
    _wsService.disconnect();
  }

  Future<List<NotificationModel>> fetchNotifications() async {
    final response = await _client.get('/notifications/?only_unread=false');
    if (response.statusCode < 200 || response.statusCode >= 300) {
      return [];
    }
    final list = jsonDecode(response.body) as List<dynamic>;
    final models = list
        .map((e) => NotificationDto.fromJson(e as Map<String, dynamic>))
        .map(NotificationMapper.fromDto)
        .toList();
    // Más recientes primero, sin asumir el orden en que responde el backend.
    models.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return models;
  }

  Future<bool> markAsRead(int notificationId) async {
    final response = await _client.patch(
      '/notifications/$notificationId/read',
      {},
    );
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  Future<bool> markAllAsRead() async {
    final response = await _client.patch('/notifications/read-all', {});
    return response.statusCode >= 200 && response.statusCode < 300;
  }
}
