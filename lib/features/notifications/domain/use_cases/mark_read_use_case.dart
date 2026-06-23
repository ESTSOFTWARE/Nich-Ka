import '../repositories/notification_repository.dart';

class MarkReadUseCase {
  final NotificationRepository _repository;

  const MarkReadUseCase(this._repository);

  Future<bool> call(int notificationId) =>
      _repository.markAsRead(notificationId);
}
