import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  // Core
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // Features - Aquí registrarás tus features en el futuro
  // Ejemplo:
  // sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  // sl.registerFactory(() => AuthViewModel(sl()));
}