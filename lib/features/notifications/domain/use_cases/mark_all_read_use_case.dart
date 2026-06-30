import '../repositories/notification_repository.dart';

class MarkAllReadUseCase {
  final NotificationRepository _repository;

  const MarkAllReadUseCase(this._repository);

  Future<bool> call() => _repository.markAllAsRead();
}
