import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../widgets/social_login_button.dart';
import '../widgets/spotlight_background.dart';

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
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                SvgPicture.asset(
                  'assets/img/logo.svg', // logo.svg
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
                color: Colors.white,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Un sistema automatizado que optimiza y controla la fermentación del café para obtener perfiles de sabor únicos y consistentes.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFFA3A3A3), // text-neutral-400
                height: 1.5,
              ),
            ),

            const SizedBox(height: 48),

            // Botones Sociales (Usamos el widget SocialLoginButton creado antes)
            SocialLoginButton(
              text: 'Continuar con Google',
              iconPath: 'assets/img/google.svg', // google.svg
              onPressed: () {
                // TODO: Implementar lógica VM
              },
            ),
            const SizedBox(height: 16),
            SocialLoginButton(
              text: 'Continuar con Correo',
              iconPath: 'assets/img/gmail.svg', // gmail.svg
              onPressed: () {
                // Navegación al flujo de correo
                context.go('/login-email');
              },
            ),

            const SizedBox(height: 32),

            // Footer: Términos
            Text(
              'Términos de Privacidad | Términos de uso',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFF525252), // text-neutral-600
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}