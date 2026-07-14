import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_filex/open_filex.dart';
import '../../features/messages/presentation/open_chat_from_push.dart';
import '../audio/active_chat.dart';
import '../network/http_client.dart';

/// Notificaciones push (FCM). Pide permiso, registra el token en el backend
/// y muestra la notificación cuando la app está en primer plano.
class PushService {
  PushService._();
  static final PushService instance = PushService._();

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static const _channel = AndroidNotificationChannel(
    'nichka_default',
    'Notificaciones',
    description: 'Alertas, fermentaciones, mensajes y avisos',
    importance: Importance.high,
  );

  bool _localReady = false;
  bool _registered = false;

  /// Inicializa el canal + listener de primer plano. Se llama al arrancar la app.
  Future<void> initLocalNotifications() async {
    if (kIsWeb || _localReady) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _local.initialize(
      const InitializationSettings(android: androidInit),
      onDidReceiveNotificationResponse: (resp) {
        final payload = resp.payload;
        if (payload != null && (resp.actionId == 'open_file' || payload.startsWith('/'))) {
          OpenFilex.open(payload);
        } else {
          _handlePayload(payload);
        }
      },
    );
    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    // App en primer plano → FCM no muestra nada solo; lo mostramos nosotros.
    FirebaseMessaging.onMessage.listen(_showForeground);

    // Tap en el push con la app en segundo plano.
    FirebaseMessaging.onMessageOpenedApp.listen((m) => _navigate(m.data));
    // App abierta desde cero por tocar un push.
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _navigate(initial.data),
      );
    }
    _localReady = true;
  }

  void _handlePayload(String? payload) {
    if (payload == null || payload.isEmpty) return;
    try {
      _navigate(jsonDecode(payload) as Map<String, dynamic>);
    } catch (_) {}
  }

  /// Abre el chat (y salta al mensaje si es una mención) a partir de los datos
  /// del push.
  void _navigate(Map<String, dynamic> data) {
    final type = data['type'];
    if (type != 'chat_message' && type != 'chat_mention') return;
    final convId = int.tryParse('${data['conversation_id']}');
    if (convId == null) return;
    final msgId = int.tryParse('${data['message_id'] ?? ''}');
    openChatFromPush(convId, messageId: msgId);
  }

  /// Pide permiso, obtiene el token FCM y lo manda al backend. Se llama tras login.
  Future<void> registerForUser() async {
    if (kIsWeb || _registered) return;
    final messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(alert: true, badge: true, sound: true);

    final token = await messaging.getToken();
    if (token != null) await _sendToken(token);

    messaging.onTokenRefresh.listen(_sendToken);
    _registered = true;
  }

  void _showForeground(RemoteMessage msg) {
    final n = msg.notification;
    if (n == null) return;

    // Si es un mensaje de chat y ya estoy dentro de esa conversación, no mostrar
    // el push (ya se ve el mensaje en pantalla + suena sound_response_message).
    if (msg.data['type'] == 'chat_message') {
      final convId = int.tryParse('${msg.data['conversation_id']}');
      if (convId != null && convId == ActiveChat.conversationId) return;
    }

    _local.show(
      n.hashCode,
      n.title,
      n.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: jsonEncode(msg.data),
    );
  }

  Future<void> showFileSaved(String fileName, String filePath) async {
    if (!_localReady) return;
    await _local.show(
      filePath.hashCode,
      'Guardado con éxito',
      fileName,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          actions: const [AndroidNotificationAction('open_file', 'Abrir')],
        ),
      ),
      payload: filePath,
    );
  }

  Future<void> _sendToken(String token) async {
    try {
      await HttpClient.instance.post('/notifications/device-token', {
        'token': token,
        'platform': 'android',
      });
    } catch (_) {
      /* si falla, se reintenta en el próximo refresh/login */
    }
  }
}
