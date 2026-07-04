import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/auth/biometric_service.dart';
import '../../../../core/auth/session_manager.dart';
import '../../../../core/navigation/entry_route.dart';
import '../../../../core/providers/auth_provider.dart';

part 'splash_gate_view_state.dart';

/// Pantalla inicial: si hay sesión guardada, pide huella y entra sin re-login.
class SplashGateView extends StatefulWidget {
  const SplashGateView({super.key});

  @override
  State<SplashGateView> createState() => _SplashGateViewState();
}
