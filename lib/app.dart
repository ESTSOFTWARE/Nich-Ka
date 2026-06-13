import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'core/presentation/app_theme_provider.dart';
import 'core/presentation/app_theme_scope.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppThemeProvider _themeProvider;

  @override
  void initState() {
    super.initState();
    _themeProvider = AppThemeProvider();
  }

  @override
  void dispose() {
    _themeProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeScope(
      notifier: _themeProvider,
      child: MaterialApp.router(
        title: 'Nich-Ká',
        debugShowCheckedModeBanner: false,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        routerConfig: appRouter,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
      ),
    );
  }
}
