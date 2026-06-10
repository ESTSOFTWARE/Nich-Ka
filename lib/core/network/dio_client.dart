import 'package:dio/dio.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.tudominio.com/v1', // Cambiar por la URL base real o variable de entorno
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Aquí podremos agregar interceptores en el futuro
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Lógica para inyectar token, por ejemplo.
          return handler.next(options);
        },
      ),
    );
  }
}