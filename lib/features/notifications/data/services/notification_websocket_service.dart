import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../core/network/http_client.dart';
import '../../domain/entities/connection_state.dart';
import '../datasource/remote/model/dto/notification_event_dto.dart';

class NotificationWebSocketService {
  NotificationWebSocketService._();
  static final NotificationWebSocketService instance =
      NotificationWebSocketService._();

  WebSocketChannel? _channel;
  StreamController<NotificationEventDto>? _eventController;
  StreamController<NotificationConnectionState>? _stateController;
  Timer? _retryTimer;
  bool _closed = false;
  int _retryAttempt = 0;
  int _userId = 0;
  String? _token;

  static const int _maxRetryDelay = 30;
  static const int _initialRetryDelay = 1;

  Stream<NotificationEventDto> get events {
    _eventController ??= StreamController<NotificationEventDto>.broadcast();
    return _eventController!.stream;
  }

  Stream<NotificationConnectionState> get connectionState {
    _stateController ??=
        StreamController<NotificationConnectionState>.broadcast();
    return _stateController!.stream;
  }

  bool get isConnected => _channel != null;

  void connect({required int userId, String? token}) {
    if (_channel != null) return;

    _closed = false;
    _retryAttempt = 0;
    _userId = userId;
    _token = token;
    _emitState(NotificationConnectionState.connecting);
    _open();
  }

  Future<void> _open() async {
    if (_closed) return;

    final token = _token ?? HttpClient.instance.accessToken;
    final base = HttpClient.wsBaseUrl;
    final uri = Uri.parse(
      '$base/ws/notifications/$_userId${token != null ? '?token=$token' : ''}',
    );

    try {
      _channel = WebSocketChannel.connect(uri);
      await _channel!.ready;
      _retryAttempt = 0;
      _emitState(NotificationConnectionState.connected);
      _channel!.stream.listen(
        _onData,
        onDone: _scheduleRetry,
        onError: (_) {
          _emitState(NotificationConnectionState.error);
          _scheduleRetry();
        },
        cancelOnError: true,
      );
    } catch (_) {
      _emitState(NotificationConnectionState.error);
      _scheduleRetry();
    }
  }

  void _onData(dynamic raw) {
    try {
      final json = jsonDecode(raw as String) as Map<String, dynamic>;
      final dto = NotificationEventDto.fromJson(json);
      if (dto.notificationId == 0) return;
      _eventController?.add(dto);
    } catch (_) {}
  }

  void _scheduleRetry() {
    _channel = null;
    if (_closed) return;

    _retryAttempt++;
    final delay = min(
      _initialRetryDelay * pow(2, _retryAttempt - 1).toInt(),
      _maxRetryDelay,
    );

    _emitState(NotificationConnectionState.reconnecting);
    _retryTimer?.cancel();
    _retryTimer = Timer(Duration(seconds: delay), _open);
  }

  void _emitState(NotificationConnectionState state) {
    _stateController?.add(state);
  }

  void disconnect() {
    _closed = true;
    _retryTimer?.cancel();
    _retryTimer = null;
    _channel?.sink.close();
    _channel = null;
    _retryAttempt = 0;
  }

  void dispose() {
    disconnect();
    _eventController?.close();
    _eventController = null;
    _stateController?.close();
    _stateController = null;
  }
}
