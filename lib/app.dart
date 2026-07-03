import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:provider/provider.dart';
import 'core/presentation/app_theme_provider.dart';
import 'core/presentation/app_theme_scope.dart';
import 'core/providers/auth_provider.dart';
import 'core/push/push_service.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/notifications/presentation/providers/notifications_provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Global: el WS de notificaciones vive en toda la app. Se conecta al
        // loguearse y se corta al salir.
        ChangeNotifierProxyProvider<AuthProvider, NotificationsProvider>(
          create: (_) => NotificationsProvider(),
          update: (_, auth, notif) {
            final n = notif ?? NotificationsProvider();
            if (auth.isLoggedIn) {
              n.connect();
              PushService.instance.registerForUser(); // token FCM al backend
            } else {
              n.reset();
            }
            return n;
          },
        ),
      ],
      child: const _AppContent(),
    );
  }
}

class _AppContent extends StatelessWidget {
  const _AppContent();

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();

    return AppThemeScope(
      notifier: themeProvider,
      child: MaterialApp.router(
        title: 'Nich-Ká',
        debugShowCheckedModeBanner: false,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        routerConfig: appRouter,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
      ),
    );
  }
}
