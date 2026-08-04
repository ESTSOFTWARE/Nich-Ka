import '../../domain/entities/connection_state.dart';
import '../../domain/entities/notification_item.dart';

/// Estado de la campana de notificaciones (global a toda la app).
class NotificationsState {
  final bool isScrolled;
  final List<NotificationItem> items;
  final NotificationConnectionState connectionState;

  const NotificationsState({
    this.isScrolled = false,
    this.items = const [],
    this.connectionState = NotificationConnectionState.connecting,
  });

  int get unreadCount => items.where((i) => !i.isRead).length;

  NotificationsState copyWith({
    bool? isScrolled,
    List<NotificationItem>? items,
    NotificationConnectionState? connectionState,
  }) => NotificationsState(
    isScrolled: isScrolled ?? this.isScrolled,
    items: items ?? this.items,
    connectionState: connectionState ?? this.connectionState,
  );
}
