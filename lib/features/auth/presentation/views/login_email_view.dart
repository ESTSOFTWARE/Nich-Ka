import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../viewmodels/login_viewmodel.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/primary_auth_button.dart';
import '../widgets/social_login_button.dart';
import '../widgets/spotlight_background.dart';

class LoginEmailView extends StatefulWidget {
  const LoginEmailView({super.key});

  @override
  State<LoginEmailView> createState() => _LoginEmailViewState();
}

class _LoginEmailViewState extends State<LoginEmailView> {
  // 1. Declaramos la variable del ViewModel
  late final LoginViewModel _viewModel;

  // 2. Inicializamos el estado al cargar la pantalla
  @override
  void initState() {
    super.initState();
    _viewModel = LoginViewModel();
  }

  // 3. Liberamos los controladores de texto al destruir la pantalla
  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpotlightBackground(
      child: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/img/logo.svg',
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
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Monitorea y optimiza la fermentación de tu café con inteligencia artificial en tiempo real.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFFA3A3A3),
                  ),
                ),
                const SizedBox(height: 48),

                // Formulario
                AuthTextField(
                  label: 'Correo electrónico',
                  hintText: 'tu@ejemplo.com',
                  controller: _viewModel.emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),

                // Contraseña con enlace de recuperación en el label
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Contraseña',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFA3A3A3),
                      ),
                    ),
                    Text(
                      '¿Olvidaste tu contraseña?',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFF525252),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                AuthTextField(
                  label: '',
                  hintText: '••••••••',
                  controller: _viewModel.passwordController,
                  isPassword: true,
                ),

                const SizedBox(height: 48),

                // Botón de Acción Principal
                PrimaryAuthButton(
                  text: 'Iniciar Sesión',
                  isLoading: _viewModel.isLoading,
                  onPressed: () async {
                    await _viewModel.loginWithEmail();
                  },
                ),
                const SizedBox(height: 24),

                // Botón Continuar con Google
                SocialLoginButton(
                  text: 'Iniciar con Google',
                  iconPath: 'assets/img/google.svg',
                  onPressed: () {
                    // TODO: Implementar lógica VM
                  },
                ),

                const SizedBox(height: 60),

                // Footer: Términos
                Center(
                  child: Text(
                    'Términos de Privacidad | Términos de uso',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF525252),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}