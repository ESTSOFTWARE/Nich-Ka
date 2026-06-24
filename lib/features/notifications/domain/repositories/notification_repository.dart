import 'dart:async';
import '../entities/connection_state.dart';
import '../entities/notification_item.dart';

abstract class NotificationRepository {
  Stream<NotificationItem> get onNotificationReceived;

  Stream<NotificationConnectionState> get connectionState;

  void connectWebSocket({required int userId, String? token});

  void disconnectWebSocket();

  Future<List<NotificationItem>> fetchNotifications();

  Future<bool> markAsRead(int notificationId);

  Future<bool> markAllAsRead();
}
