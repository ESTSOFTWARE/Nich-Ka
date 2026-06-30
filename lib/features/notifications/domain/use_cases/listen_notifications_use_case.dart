import 'dart:async';
import '../entities/notification_item.dart';
import '../repositories/notification_repository.dart';

class ListenNotificationsUseCase {
  final NotificationRepository _repository;

  const ListenNotificationsUseCase(this._repository);

  Stream<NotificationItem> call() => _repository.onNotificationReceived;
}
