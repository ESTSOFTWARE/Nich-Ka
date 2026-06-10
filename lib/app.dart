import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nich-Ká',
      debugShowCheckedModeBanner: false,

      // Configuraciones requeridas para Device Preview (Corregido)
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      // Configuración de Rutas (GoRouter)
      routerConfig: appRouter,

      // Configuración de Tema (Light/Dark Mode)
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}