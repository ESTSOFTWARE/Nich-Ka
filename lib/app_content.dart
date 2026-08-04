part of 'app.dart';

class _AppContent extends ConsumerWidget {
  const _AppContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mantiene sincronizado el WS de notificaciones con el login.
    ref.watch(authNotificationsBinderProvider);
    final themeProvider = ref.watch(appThemeProvider);

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
        themeMode: themeProvider.themeMode,
      ),
    );
  }
}
