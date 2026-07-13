import '../../../core/network/http_client.dart';
import '../data/datasource/remote/notification_datasource.dart';
import '../data/repositories/notification_repository_impl.dart';
import '../domain/use_cases/connect_notifications_use_case.dart';
import '../domain/use_cases/fetch_notifications_use_case.dart';
import '../domain/use_cases/listen_notifications_use_case.dart';
import '../domain/use_cases/mark_all_read_use_case.dart';
import '../domain/use_cases/mark_read_use_case.dart';
import '../domain/use_cases/watch_connection_state_use_case.dart';

class NotificationsDependencies {
  NotificationsDependencies._();

  static final NotificationDatasource _dataSource = NotificationDatasource(
    HttpClient.instance,
  );

  static final NotificationRepositoryImpl _repository =
      NotificationRepositoryImpl(_dataSource);

  static FetchNotificationsUseCase get fetchNotifications =>
      FetchNotificationsUseCase(_repository);

  static MarkReadUseCase get markRead => MarkReadUseCase(_repository);

  static MarkAllReadUseCase get markAllRead => MarkAllReadUseCase(_repository);

  static ConnectNotificationsUseCase get connect =>
      ConnectNotificationsUseCase(_repository);

  static ListenNotificationsUseCase get listen =>
      ListenNotificationsUseCase(_repository);

  static WatchConnectionStateUseCase get watchConnectionState =>
      WatchConnectionStateUseCase(_repository);
}
