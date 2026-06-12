import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/change_notifier_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/login_provider.dart';
import '../states/ui_state.dart';
import '../components/auth_text_field.dart';
import '../components/auth_field_label.dart';
import '../components/legal_footer.dart';
import '../components/primary_auth_button.dart';
import '../components/social_login_button.dart';
import '../components/spotlight_background.dart';

/// Pantalla de inicio de sesión con correo. Responsabilidad única: componer la
/// UI. El ciclo de vida del [LoginProvider] lo gestiona [ChangeNotifierProvider].
class LoginEmailView extends StatelessWidget {
  const LoginEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginProvider>(
      create: () => LoginProvider(),
      builder: (context, provider) {
        return SpotlightBackground(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Nich-Ká + Logo
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
                    SvgPicture.asset(
                      'assets/icons/logo.svg',
                      height: 40,
                    ),
                  ],
                ),
                const SizedBox(height: 60),

                // Textos Encabezado
                Text(
                  '¡Bienvenido de nuevo!',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Monitorea y optimiza la fermentación de tu café con inteligencia artificial en tiempo real.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 48),

                // Formulario
                AuthTextField(
                  label: 'Correo electrónico',
                  hintText: 'tu@ejemplo.com',
                  controller: provider.emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),

                // Contraseña con enlace de recuperación en el label
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AuthFieldLabel(text: 'Contraseña'),
                    GestureDetector(
                      onTap: () => context.push('/forgot-password'),
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                AuthTextField(
                  label: '',
                  hintText: '••••••••',
                  controller: provider.passwordController,
                  isPassword: true,
                  isObscured: provider.isPasswordObscured,
                  onToggleObscure: provider.togglePasswordVisibility,
                ),

                const SizedBox(height: 48),

                // Botón de Acción Principal
                PrimaryAuthButton(
                  text: 'Iniciar Sesión',
                  iconPath: 'assets/icons/login.svg',
                  filled: false,
                  isLoading: provider.loginState is UiLoading,
                  onPressed: () async {
                    await provider.loginWithEmail();
                  },
                ),
                const SizedBox(height: 24),

                // Botón Continuar con Google
                SocialLoginButton(
                  text: 'Iniciar con Google',
                  iconPath: 'assets/icons/google.svg',
                  onPressed: () {
                    // TODO: Implementar lógica VM
                  },
                ),

                const SizedBox(height: 32),
                const Divider(color: AppColors.border, height: 1),
                const SizedBox(height: 28),

                // Footer: Términos
                const LegalFooter(),
              ],
            ),
          ),
        );
      },
    );
  }
}
