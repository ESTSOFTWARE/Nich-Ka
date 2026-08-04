import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/biometric_service.dart';
import '../../../../core/auth/session_manager.dart';
import '../../../../core/navigation/entry_route.dart';
import '../../../../core/network/http_client.dart';
import '../../../../core/providers/global_providers.dart';

part 'splash_gate_view_state.dart';

class SplashGateView extends ConsumerStatefulWidget {
  const SplashGateView({super.key});

  @override
  ConsumerState<SplashGateView> createState() => _SplashGateViewState();
}
