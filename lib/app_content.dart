part of 'app.dart';

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
        themeMode: themeProvider.themeMode,
      ),
    );
  }
}
