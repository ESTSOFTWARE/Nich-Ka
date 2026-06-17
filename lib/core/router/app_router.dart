import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../network/http_client.dart';
import '../../features/auth/presentation/pages/login_email_view.dart';
import '../../features/auth/presentation/pages/login_view.dart';
import '../../features/auth/presentation/pages/forgot_password_view.dart';
import '../../features/auth/presentation/pages/change_password_view.dart';
import '../../features/legal/presentation/pages/privacy_policy_view.dart';
import '../../features/legal/presentation/pages/terms_of_use_view.dart';
import '../../features/profile/presentation/pages/profile_view.dart';
import '../../features/home/presentation/pages/assistant_empty_view.dart';
import '../../features/home/presentation/pages/assistant_view.dart';
import '../../features/home/presentation/pages/home_student_view.dart';
import '../../features/home/presentation/pages/home_view.dart';
import '../../features/chat/presentation/pages/chat_view.dart';
import '../../features/notifications/presentation/pages/notifications_view.dart';
import '../../features/fermentation/presentation/pages/fermentation_detail_view.dart';
import '../../features/fermentation/presentation/pages/fermentation_list_view.dart';
import '../../features/home/presentation/pages/overview_view.dart';
import '../../features/reports/presentation/pages/report_detail_view.dart';
import '../../features/reports/presentation/pages/reports_view.dart';
import '../../features/calculator/presentation/pages/calculator_view.dart';
import '../../features/class/domain/entities/class_detail.dart';
import '../../features/class/presentation/pages/class_detail_view.dart';
import '../../features/class/presentation/pages/class_list_view.dart';
import '../../features/class/presentation/pages/join_class_view.dart';
import '../../features/sensors/domain/entities/sensor_reading.dart';
import '../../features/sensors/presentation/pages/sensor_detail_view.dart';
import '../../features/sensors/presentation/pages/sensors_view.dart';
import '../../features/simulator/presentation/pages/simulator_view.dart';

/// Código de clase pendiente capturado de un deep link (`/join?code=...`)
/// mientras el usuario aún no inicia sesión. Tras el login se consume.
String? pendingJoinCode;

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  redirect: (BuildContext context, GoRouterState state) {
    // Deep link a /join sin sesión → guardar el código y mandar al login.
    if (state.matchedLocation == '/join' && !HttpClient.instance.hasToken) {
      pendingJoinCode = state.uri.queryParameters['code'];
      return '/login';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) =>
          const HomeStudentView(),
    ),
    GoRoute(
      path: '/assistant-empty',
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
      path: '/assistant',
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
    GoRoute(
      path: '/reports',
      builder: (BuildContext context, GoRouterState state) =>
          const ReportsView(),
    ),
    GoRoute(
      path: '/report-detail',
      builder: (BuildContext context, GoRouterState state) =>
          const ReportDetailView(),
    ),
    GoRoute(
      path: '/calculator',
      builder: (BuildContext context, GoRouterState state) =>
          const CalculatorView(),
    ),
    GoRoute(
      path: '/simulator',
      builder: (BuildContext context, GoRouterState state) =>
          const SimulatorView(),
    ),
    GoRoute(
      path: '/class',
      builder: (BuildContext context, GoRouterState state) =>
          const JoinClassView(),
    ),
    // Deep link: nich-ka.space/join?code=XXXX → unirse a la clase con el código
    GoRoute(
      path: '/join',
      builder: (BuildContext context, GoRouterState state) => JoinClassView(
        initialCode: state.uri.queryParameters['code'],
      ),
    ),
    GoRoute(
      path: '/classes',
      builder: (BuildContext context, GoRouterState state) =>
          const ClassListView(),
    ),
    GoRoute(
      path: '/sensors',
      builder: (BuildContext context, GoRouterState state) =>
          const SensorsView(),
    ),
    GoRoute(
      path: '/sensor-detail',
      builder: (BuildContext context, GoRouterState state) =>
          SensorDetailView(reading: state.extra as SensorReading),
    ),
    GoRoute(
      path: '/class-detail',
      builder: (BuildContext context, GoRouterState state) =>
          ClassDetailView(detail: state.extra as ClassDetail),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Error: Ruta no encontrada (${state.error})')),
  ),
);
