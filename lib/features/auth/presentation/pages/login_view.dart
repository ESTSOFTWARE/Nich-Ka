import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../components/legal_footer.dart';
import '../components/social_login_button.dart';
import '../components/spotlight_background.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return SpotlightBackground(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Header: Nich-Ká + Logo (SRP: Podrías extraer esto a un widget)
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
                  'assets/icons/logo.svg', // logo.svg
                  height: 40,
                ),
              ],
            ),
            const Spacer(),

            // Imagen central animada (Placeholder por ahora)
            Image.asset(
              'assets/img/nich-ka-animado.png', // nich-ka-animado.png
              height: 250,
              fit: BoxFit.contain,
            ),

            const Spacer(),

            // Textos descriptivos
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

            // Botones Sociales (Usamos el widget SocialLoginButton creado antes)
            SocialLoginButton(
              text: 'Continuar con Google',
              iconPath: 'assets/icons/google.svg', // google.svg
              onPressed: () {
                // TODO: Implementar lógica VM
              },
            ),
            const SizedBox(height: 16),
            SocialLoginButton(
              text: 'Continuar con Correo',
              iconPath: 'assets/icons/gmail.svg', // gmail.svg
              onPressed: () {
                // Navegación al flujo de correo
                context.go('/login-email');
              },
            ),

            const SizedBox(height: 32),

            // Footer: Términos
            const LegalFooter(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}