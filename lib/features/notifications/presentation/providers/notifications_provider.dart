import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/audio/sound_service.dart';
import '../../../../core/network/http_client.dart';
import '../../data/datasource/remote/notification_datasource.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/entities/connection_state.dart';
import '../../domain/entities/notification_item.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/use_cases/connect_notifications_use_case.dart';
import '../../domain/use_cases/fetch_notifications_use_case.dart';
import '../../domain/use_cases/listen_notifications_use_case.dart';
import '../../domain/use_cases/mark_all_read_use_case.dart';
import '../../domain/use_cases/mark_read_use_case.dart';
import '../../domain/use_cases/watch_connection_state_use_case.dart';

class NotificationsProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  bool _isScrolled = false;
  bool get isScrolled => _isScrolled;

  final ConnectNotificationsUseCase _connect;
  final ListenNotificationsUseCase _listen;
  final FetchNotificationsUseCase _fetch;
  final MarkReadUseCase _markRead;
  final MarkAllReadUseCase _markAllRead;
  final WatchConnectionStateUseCase _watchState;
  StreamSubscription<NotificationItem>? _sub;
  StreamSubscription<NotificationConnectionState>? _stateSub;

  NotificationConnectionState _connectionState =
      NotificationConnectionState.connecting;
  NotificationConnectionState get connectionState => _connectionState;

  NotificationsProvider({NotificationRepository? repository})
    : this._(
        repository ??
            NotificationRepositoryImpl(
              NotificationDatasource(HttpClient.instance),
            ),
      );

  NotificationsProvider._(NotificationRepository repository)
    : _connect = ConnectNotificationsUseCase(repository),
      _listen = ListenNotificationsUseCase(repository),
      _fetch = FetchNotificationsUseCase(repository),
      _markRead = MarkReadUseCase(repository),
      _markAllRead = MarkAllReadUseCase(repository),
      _watchState = WatchConnectionStateUseCase(repository) {
    scrollController.addListener(_onScroll);
  }

  bool _connected = false;

  /// Conecta el WebSocket y carga las notificaciones. Idempotente: se llama
  /// tras el login (desde el ProxyProvider en app.dart). Global a toda la app.
  Future<void> connect() async {
    if (_connected) return;
    final userId = HttpClient.instance.userId;
    if (userId == 0) return;
    _connected = true;

    _stateSub = _watchState().listen(_onConnectionState);
    _connect(userId: userId);
    // Configurar listener ANTES del fetch: si llega una notificación mientras
    // el HTTP está en vuelo (p.ej. fermentation_started justo al abrir la app),
    // el broadcast stream ya tiene listener y no se pierde el evento.
    _sub = _listen().listen(_onNotificationReceived);

    // El datasource ya entrega las más recientes primero.
    _items = await _fetch();
    notifyListeners();
  }

  /// Corta todo (al cerrar sesión).
  void reset() {
    _sub?.cancel();
    _stateSub?.cancel();
    _sub = null;
    _stateSub = null;
    _items = const [];
    _connected = false;
    notifyListeners();
  }

  void _onConnectionState(NotificationConnectionState state) {
    _connectionState = state;
    notifyListeners();
  }

  void _onNotificationReceived(NotificationItem item) {
    _items = [item, ..._items];
    notifyListeners();
    SoundService.instance.notification();
  }

  List<NotificationItem> _items = const [];

  List<NotificationItem> get items => _items;

  int get unreadCount => _items.where((i) => !i.isRead).length;

  Future<void> markAsRead(int notificationId) async {
    final ok = await _markRead(notificationId);
    if (!ok) return;
    _items = _items.map((i) {
      if (i.id == notificationId) return i.copyWith(isRead: true);
      return i;
    }).toList();
    notifyListeners();
  }

  Future<void> markAllRead() async {
    await _markAllRead();
    _items = _items.map((i) => i.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  void _onScroll() {
    final scrolled = scrollController.offset > 4;
    if (scrolled != _isScrolled) {
      _isScrolled = scrolled;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    _stateSub?.cancel();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }
}
