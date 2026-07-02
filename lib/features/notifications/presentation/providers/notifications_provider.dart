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
    _init();
  }

  Future<void> _init() async {
    final userId = HttpClient.instance.userId;
    if (userId == 0) return;

    _stateSub = _watchState().listen(_onConnectionState);
    _connect(userId: userId);

    final items = await _fetch();
    _items = items.reversed.toList();
    notifyListeners();

    _sub = _listen().listen(_onNotificationReceived);
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
