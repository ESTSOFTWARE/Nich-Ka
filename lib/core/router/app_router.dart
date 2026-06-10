import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/views/login_email_view.dart';
import '../../features/auth/presentation/views/login_view.dart'; // Nueva vista

final GoRouter appRouter = GoRouter(
  // Cambiamos la ubicación inicial a la pantalla de login por correo para probarla directamente
  initialLocation: '/login',
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
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) => const LoginView(),
    ),
    GoRoute(
      path: '/login-email',
      builder: (BuildContext context, GoRouterState state) => const LoginEmailView(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Error: Ruta no encontrada (${state.error})'),
    ),
  ),
);