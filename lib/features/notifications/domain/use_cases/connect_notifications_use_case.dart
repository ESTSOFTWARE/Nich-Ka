import '../repositories/notification_repository.dart';

class ConnectNotificationsUseCase {
  final NotificationRepository _repository;

  const ConnectNotificationsUseCase(this._repository);

  void call({required int userId, String? token}) {
    _repository.connectWebSocket(userId: userId, token: token);
  }
}
