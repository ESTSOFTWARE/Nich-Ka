import 'dart:async';

import '../../domain/entities/connection_state.dart';
import '../../domain/entities/notification_item.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasource/remote/notification_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDatasource _dataSource;

  const NotificationRepositoryImpl(this._dataSource);

  @override
  Stream<NotificationItem> get onNotificationReceived =>
      _dataSource.onNotificationReceived.map((m) => m.toEntity());

  @override
  Stream<NotificationConnectionState> get connectionState =>
      _dataSource.connectionState;

  @override
  void connectWebSocket({required int userId, String? token}) {
    _dataSource.connectWebSocket(userId: userId, token: token);
  }

  @override
  void disconnectWebSocket() {
    _dataSource.disconnectWebSocket();
  }

  @override
  Future<List<NotificationItem>> fetchNotifications() async {
    final models = await _dataSource.fetchNotifications();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<bool> markAsRead(int notificationId) async {
    return _dataSource.markAsRead(notificationId);
  }

  @override
  Future<bool> markAllAsRead() async {
    return _dataSource.markAllAsRead();
  }
}
