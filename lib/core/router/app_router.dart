import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_email_view.dart';
import '../../features/auth/presentation/pages/login_view.dart';
import '../../features/auth/presentation/pages/forgot_password_view.dart';
import '../../features/auth/presentation/pages/change_password_view.dart';
import '../../features/legal/presentation/pages/privacy_policy_view.dart';
import '../../features/legal/presentation/pages/terms_of_use_view.dart';
import '../../features/profile/presentation/pages/profile_view.dart';
import '../../features/home/presentation/pages/assistant_empty_view.dart';
import '../../features/home/presentation/pages/assistant_view.dart';
import '../../features/home/presentation/pages/home_view.dart';
import '../../features/chat/presentation/pages/chat_view.dart';
import '../../features/notifications/presentation/pages/notifications_view.dart';
import '../../features/fermentation/presentation/pages/fermentation_detail_view.dart';
import '../../features/fermentation/presentation/pages/fermentation_list_view.dart';
import '../../features/home/presentation/pages/overview_view.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) =>
          const AssistantEmptyView(),
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) => const LoginView(),
    ),
    GoRoute(
      path: '/login-email',
      builder: (BuildContext context, GoRouterState state) =>
          const LoginEmailView(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (BuildContext context, GoRouterState state) =>
          const ForgotPasswordView(),
    ),
    GoRoute(
      path: '/privacy',
      builder: (BuildContext context, GoRouterState state) =>
          const PrivacyPolicyView(),
    ),
    GoRoute(
      path: '/terms',
      builder: (BuildContext context, GoRouterState state) =>
          const TermsOfUseView(),
    ),
    GoRoute(
      path: '/profile',
      builder: (BuildContext context, GoRouterState state) =>
          const ProfileView(),
    ),
    GoRoute(
      path: '/change-password',
      builder: (BuildContext context, GoRouterState state) =>
          const ChangePasswordView(),
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) => const HomeView(),
    ),
    GoRoute(
      path: '/overview',
      builder: (BuildContext context, GoRouterState state) =>
          const OverviewView(),
    ),
    GoRoute(
      path: '/asistente',
      builder: (BuildContext context, GoRouterState state) =>
          const AssistantView(),
    ),
    GoRoute(
      path: '/fermentations',
      builder: (BuildContext context, GoRouterState state) =>
          const FermentationListView(),
    ),
    GoRoute(
      path: '/fermentation',
      builder: (BuildContext context, GoRouterState state) =>
          const FermentationDetailView(),
    ),
    GoRoute(
      path: '/chat',
      builder: (BuildContext context, GoRouterState state) => const ChatView(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (BuildContext context, GoRouterState state) =>
          const NotificationsView(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Error: Ruta no encontrada (${state.error})')),
  ),
);
