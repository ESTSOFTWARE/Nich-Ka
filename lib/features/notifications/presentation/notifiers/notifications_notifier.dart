import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/audio/sound_service.dart';
import '../../../../core/network/http_client.dart';
import '../../di/notifications_dependencies.dart';
import '../../domain/entities/connection_state.dart';
import '../../domain/entities/notification_item.dart';
import 'notifications_state.dart';

export 'notifications_state.dart';

/// Campana de notificaciones global. Reemplaza al antiguo NotificationsProvider
/// (ChangeNotifier). No es autoDispose: el WebSocket vive mientras haya sesión;
/// se conecta/desconecta desde authNotificationsBinderProvider según el login.
class NotificationsNotifier extends Notifier<NotificationsState> {
  final ScrollController scrollController = ScrollController();

  StreamSubscription<NotificationItem>? _sub;
  StreamSubscription<NotificationConnectionState>? _stateSub;
  bool _connected = false;

  @override
  NotificationsState build() {
    scrollController.addListener(_onScroll);
    ref.onDispose(() {
      _sub?.cancel();
      _stateSub?.cancel();
      scrollController.removeListener(_onScroll);
      scrollController.dispose();
    });
    return const NotificationsState();
  }

  /// Conecta el WebSocket y carga las notificaciones. Idempotente: se llama
  /// tras el login (desde authNotificationsBinderProvider). Global a la app.
  Future<void> connect() async {
    if (_connected) return;
    final userId = HttpClient.instance.userId;
    if (userId == 0) return;
    _connected = true;

    _stateSub = NotificationsDependencies.watchConnectionState().listen(
      _onConnectionState,
    );
    NotificationsDependencies.connect(userId: userId);
    // Configurar listener ANTES del fetch: si llega una notificación mientras
    // el HTTP está en vuelo (p.ej. fermentation_started justo al abrir la app),
    // el broadcast stream ya tiene listener y no se pierde el evento.
    _sub = NotificationsDependencies.listen().listen(_onNotificationReceived);

    // El datasource ya entrega las más recientes primero.
    final items = await NotificationsDependencies.fetchNotifications();
    state = state.copyWith(items: items);
  }

  /// Corta todo (al cerrar sesión).
  void reset() {
    _sub?.cancel();
    _stateSub?.cancel();
    _sub = null;
    _stateSub = null;
    _connected = false;
    state = state.copyWith(items: const []);
  }

  void _onConnectionState(NotificationConnectionState connectionState) {
    state = state.copyWith(connectionState: connectionState);
  }

  void _onNotificationReceived(NotificationItem item) {
    state = state.copyWith(items: [item, ...state.items]);
    SoundService.instance.notification();
  }

  Future<void> markAsRead(int notificationId) async {
    final ok = await NotificationsDependencies.markRead(notificationId);
    if (!ok) return;
    state = state.copyWith(
      items: state.items
          .map((i) => i.id == notificationId ? i.copyWith(isRead: true) : i)
          .toList(),
    );
  }

  Future<void> markAllRead() async {
    await NotificationsDependencies.markAllRead();
    state = state.copyWith(
      items: state.items.map((i) => i.copyWith(isRead: true)).toList(),
    );
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != state.isScrolled) {
      state = state.copyWith(isScrolled: scrolled);
    }
  }
}

final notificationsProvider =
    NotifierProvider<NotificationsNotifier, NotificationsState>(
      NotificationsNotifier.new,
    );
