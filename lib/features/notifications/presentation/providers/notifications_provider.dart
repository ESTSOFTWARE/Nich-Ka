import 'package:flutter/material.dart';
import '../../domain/entities/notification_item.dart';
import '../../domain/entities/notification_type.dart';

class NotificationsProvider extends ChangeNotifier {
  List<NotificationItem> _items = const [
    NotificationItem(
      id: '1',
      title: 'Recomendación IA',
      description: 'Reduce 1.5 °C en F-024 para perfil floral.',
      time: 'ahora',
      type: NotificationType.recommendation,
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'Alerta de pH',
      description: 'F-024 cruzó pH 4.2 — fase pico iniciada.',
      time: '12m',
      type: NotificationType.alert,
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      title: 'Fermentación completada',
      description: 'F-022 Bourbon Natural finalizó secado (calidad 87.2 SCA).',
      time: '2h',
      type: NotificationType.completed,
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'Análisis disponible',
      description: 'Reporte sensorial de F-021 listo para revisar.',
      time: '1d',
      type: NotificationType.analysis,
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      title: 'Sensor desconectado',
      description: 'Sensor de pH del Tanque 03 sin señal por 10m.',
      time: '2d',
      type: NotificationType.sensor,
      isRead: true,
    ),
  ];

  List<NotificationItem> get items => _items;

  int get unreadCount => _items.where((i) => !i.isRead).length;

  void markAllRead() {
    _items = _items.map((i) => i.copyWith(isRead: true)).toList();
    notifyListeners();
  }
}
