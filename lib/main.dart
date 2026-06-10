import 'package:flutter/foundation.dart'; // Requerido para kReleaseMode
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart'; // <-- IMPORTADO
import 'core/di/injection_container.dart' as di;
import 'app.dart';

void main() async {
  // 1. Asegurar que los bindings de Flutter estén inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializar inyección de dependencias (GetIt)
  await di.init();

  // 3. Ejecutar la app envuelta en DevicePreview
  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // Activo solo en desarrollo, desactivado en producción
      builder: (context) => const App(),
    ),
  );
}