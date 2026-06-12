import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/change_notifier_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/forgot_password_provider.dart';
import '../states/ui_state.dart';
import '../components/auth_text_field.dart';
import '../components/primary_auth_button.dart';
import '../components/spotlight_background.dart';

/// Pantalla de recuperación de contraseña. Responsabilidad única: componer la
/// UI. El ciclo de vida del [ForgotPasswordProvider] lo gestiona
/// [ChangeNotifierProvider].
class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ForgotPasswordProvider>(
      create: () => ForgotPasswordProvider(),
      builder: (context, provider) {
        return SpotlightBackground(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Logo + Nich-Ká
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/logo.svg', height: 32),
                    const SizedBox(width: 10),
                    Text(
                      'Nich-Ká',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),

                // Encabezado
                Text(
                  '¿Olvidaste tu contraseña?',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Ingresa tu correo y te enviaremos un código para restablecer tu contraseña.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),

                // Formulario
                AuthTextField(
                  label: 'Correo electrónico',
                  hintText: 'tu@correo.com',
                  controller: provider.emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),

                // Botón Enviar código (blanco)
                PrimaryAuthButton(
                  text: 'Enviar código',
                  isLoading: provider.sendState is UiLoading,
                  onPressed: () async {
                    await provider.sendCode();
                  },
                ),
                const SizedBox(height: 24),

                // Volver al inicio de sesión
                Center(
                  child: TextButton(
                    onPressed: () => context.go('/login-email'),
                    child: Text(
                      '← Volver al inicio de sesión',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
