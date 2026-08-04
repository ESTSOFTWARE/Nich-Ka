import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/home_provider.dart';

export '../providers/home_provider.dart';

/// El home con fermentación activa mantiene estado mutable en vivo (sesión,
/// sensores, predicción automática, ticker). Se expone vía ChangeNotifierProvider
/// de Riverpod para conservar la lógica existente. autoDispose: libera streams
/// y timers al salir del home.
final homeProvider = ChangeNotifierProvider.autoDispose<HomeProvider>(
  (ref) => HomeProvider(),
);
