import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/presentation/app_theme_scope.dart';
import 'core/providers/global_providers.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

part 'app_content.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // ProviderScope ya envuelve la app en main.dart; aquí solo el contenido.
    return const _AppContent();
  }
}
