import 'dart:async';
import '../entities/connection_state.dart';
import '../repositories/notification_repository.dart';

class WatchConnectionStateUseCase {
  final NotificationRepository _repository;

  const WatchConnectionStateUseCase(this._repository);

  Stream<NotificationConnectionState> call() => _repository.connectionState;
}
