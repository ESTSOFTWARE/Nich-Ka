import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/navigation/entry_route.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../notifiers/login_notifier.dart';
import '../states/ui_state.dart';
import '../components/legal_footer.dart';
import '../components/social_login_button.dart';
import '../components/spotlight_background.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SpotlightBackground(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nich-Ká',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                SvgPicture.asset('assets/icons/logo.svg', height: 40),
              ],
            ),
            const Spacer(),

            Image.asset(
              'assets/img/nich-ka-animado.png',
              height: 250,
              fit: BoxFit.contain,
            ),

            const Spacer(),

            Text(
              'Comienza tu experiencia',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Un sistema automatizado que optimiza y controla la fermentación del café para obtener perfiles de sabor únicos y consistentes.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 48),

            SocialLoginButton(
              text: 'Continuar con Google',
              iconPath: 'assets/icons/google.svg',
              onPressed: () async {
                final ok = await ref
                    .read(loginProvider.notifier)
                    .loginWithGoogle();
                if (!context.mounted) return;
                if (!ok) {
                  final loginState = ref.read(loginProvider);
                  final msg = loginState.status is UiError
                      ? (loginState.status as UiError).message
                      : 'No se pudo iniciar sesión con Google.';
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(msg)));
                  return;
                }
                final token = ref.read(loginProvider).token;
                if (token != null) {
                  context.read<AuthProvider>().setUser(token);
                }
                final code = pendingJoinCode;
                if (code != null) {
                  pendingJoinCode = null;
                  context.go('/join?code=$code');
                } else {
                  final route = await resolveEntryRoute();
                  if (context.mounted) context.go(route);
                }
              },
            ),
            const SizedBox(height: 16),
            SocialLoginButton(
              text: 'Continuar con Correo',
              iconPath: 'assets/icons/gmail.svg',
              onPressed: () {
                context.go('/login-email');
              },
            ),

            const SizedBox(height: 32),

            const LegalFooter(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
