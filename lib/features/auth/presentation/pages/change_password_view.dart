import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/validation/validators.dart';
import '../notifiers/change_password_notifier.dart';
import '../states/ui_state.dart';
import '../components/auth_text_field.dart';
import '../components/primary_auth_button.dart';
import '../components/spotlight_background.dart';
import '../../../../shared/components/circle_icon_button.dart';
import '../../../../core/presentation/responsive_center.dart';

part 'change_password_view_state.dart';

class ChangePasswordView extends ConsumerStatefulWidget {
  const ChangePasswordView({super.key});

  @override
  ConsumerState<ChangePasswordView> createState() => _ChangePasswordViewState();
}
