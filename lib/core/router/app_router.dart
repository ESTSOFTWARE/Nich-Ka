import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const Scaffold(
          body: Center(
            child: Text('Nich-Ká App Inicializada'),
          ),
        );
      },
    ),
    // Agregar más rutas aquí conforme se vayan creando las features
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Error: Ruta no encontrada (${state.error})'),
    ),
  ),
);