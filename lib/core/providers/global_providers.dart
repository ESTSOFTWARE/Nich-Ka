import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation/app_theme_provider.dart';
import '../push/push_service.dart';
import '../../features/notifications/presentation/notifiers/notifications_notifier.dart';
import 'auth_notifier.dart';

// Reexporta auth y notifications para que los consumidores sigan importando
// un único punto (global_providers.dart).
export 'auth_notifier.dart';
export '../../features/notifications/presentation/notifiers/notifications_notifier.dart';

/// Tema de la app. Sigue siendo ChangeNotifier porque AppThemeScope es un
/// InheritedNotifier que necesita un Listenable; se expone vía el puente
/// ChangeNotifierProvider de Riverpod.
final appThemeProvider = ChangeNotifierProvider<AppThemeProvider>(
  (ref) => AppThemeProvider(),
);

/// Conecta/desconecta el WebSocket de notificaciones según el login,
/// replicando el antiguo ChangeNotifierProxyProvider. Se reejecuta cuando
/// cambia el estado de sesión (login/logout).
///
/// La conexión/desconexión se difiere a un microtask porque Riverpod no
/// permite modificar otro provider (notifications) durante el build de este.
final authNotificationsBinderProvider = Provider<void>((ref) {
  final isLoggedIn = ref.watch(authProvider.select((s) => s.isLoggedIn));
  Future.microtask(() {
    final notifier = ref.read(notificationsProvider.notifier);
    if (isLoggedIn) {
      notifier.connect();
      PushService.instance.registerForUser(); // token FCM al backend
    } else {
      notifier.reset();
    }
  });
});
