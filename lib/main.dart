import 'package:flutter/material.dart';
import 'core/di/injection_container.dart' as di;
import 'app.dart';

void main() async {
  // 1. Asegurar que los bindings de Flutter estén inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializar inyección de dependencias (GetIt)
  await di.init();

  runApp(const App());
}