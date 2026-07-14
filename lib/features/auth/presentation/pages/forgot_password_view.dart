import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/validation/validators.dart';
import '../notifiers/forgot_password_notifier.dart';
import '../states/ui_state.dart';
import '../components/auth_text_field.dart';
import '../components/primary_auth_button.dart';
import '../components/spotlight_background.dart';

class ForgotPasswordView extends ConsumerStatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  ConsumerState<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends ConsumerState<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sendState = ref.watch(forgotPasswordProvider);

    return SpotlightBackground(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              AuthTextField(
                label: 'Correo electrónico',
                hintText: 'tu@correo.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                maxLength: 254,
                validator: Validators.email,
              ),
              const SizedBox(height: 24),

              PrimaryAuthButton(
                text: 'Enviar código',
                isLoading: sendState is UiLoading,
                onPressed: () async {
                  if (!(_formKey.currentState?.validate() ?? false)) return;
                  await ref
                      .read(forgotPasswordProvider.notifier)
                      .sendCode(_emailController.text.trim());
                },
              ),
              const SizedBox(height: 24),

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
      ),
    );
  }
}
