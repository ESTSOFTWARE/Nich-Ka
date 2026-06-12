import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_email_view.dart';
import '../../features/auth/presentation/pages/login_view.dart';
import '../../features/auth/presentation/pages/forgot_password_view.dart';
import '../../features/legal/presentation/pages/privacy_policy_view.dart';
import '../../features/legal/presentation/pages/terms_of_use_view.dart';

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
    GoRoute(
      path: '/forgot-password',
      builder: (BuildContext context, GoRouterState state) => const ForgotPasswordView(),
    ),
    GoRoute(
      path: '/privacy',
      builder: (BuildContext context, GoRouterState state) => const PrivacyPolicyView(),
    ),
    GoRoute(
      path: '/terms',
      builder: (BuildContext context, GoRouterState state) => const TermsOfUseView(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Error: Ruta no encontrada (${state.error})'),
    ),
  ),
);