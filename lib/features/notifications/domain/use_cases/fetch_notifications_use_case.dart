import '../entities/notification_item.dart';
import '../repositories/notification_repository.dart';

class FetchNotificationsUseCase {
  final NotificationRepository _repository;

  const FetchNotificationsUseCase(this._repository);

  Future<List<NotificationItem>> call() => _repository.fetchNotifications();
}
