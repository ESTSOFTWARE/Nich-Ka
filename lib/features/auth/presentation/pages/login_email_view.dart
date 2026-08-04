import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/global_providers.dart';
import '../../../../core/navigation/entry_route.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/validation/validators.dart';
import '../notifiers/login_notifier.dart';
import '../notifiers/login_state.dart';
import '../states/ui_state.dart';
import '../components/auth_text_field.dart';
import '../components/auth_field_label.dart';
import '../components/legal_footer.dart';
import '../components/primary_auth_button.dart';
import '../components/social_login_button.dart';
import '../components/spotlight_background.dart';
import '../../../../core/presentation/responsive.dart';

part 'login_email_view_state.dart';

class LoginEmailView extends ConsumerStatefulWidget {
  const LoginEmailView({super.key});

  @override
  ConsumerState<LoginEmailView> createState() => _LoginEmailViewState();
}
