import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nich-Ká',
      debugShowCheckedModeBanner: false,

      // Configuración de Rutas (GoRouter)
      routerConfig: appRouter,

      // Configuración de Tema (Light/Dark Mode)
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}