import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/change_notifier_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/change_password_provider.dart';
import '../states/ui_state.dart';
import '../components/auth_text_field.dart';
import '../components/primary_auth_button.dart';
import '../components/spotlight_background.dart';
import '../../../../shared/components/circle_icon_button.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChangePasswordProvider>(
      create: () => ChangePasswordProvider(),
      builder: (context, provider) {
        final state = provider.state;

        return SpotlightBackground(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleIconButton(
                  icon: Icons.arrow_back_ios_new,
                  backgroundColor: AppColors.surface,
                  borderColor: AppColors.border,
                  iconColor: AppColors.textPrimary,
                  onTap: () =>
                      context.canPop() ? context.pop() : context.go('/profile'),
                ),
                const SizedBox(height: 32),

                Text(
                  'Cambiar contraseña',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ingresa tu contraseña actual y define una nueva para proteger tu cuenta.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),

                AuthTextField(
                  label: 'Contraseña actual',
                  hintText: '••••••••',
                  controller: provider.currentController,
                  isPassword: true,
                  isObscured: provider.currentObscured,
                  onToggleObscure: provider.toggleCurrentObscured,
                ),
                const SizedBox(height: 24),

                AuthTextField(
                  label: 'Nueva contraseña',
                  hintText: '••••••••',
                  controller: provider.newController,
                  isPassword: true,
                  isObscured: provider.newObscured,
                  onToggleObscure: provider.toggleNewObscured,
                ),
                const SizedBox(height: 24),

                AuthTextField(
                  label: 'Confirmar contraseña',
                  hintText: '••••••••',
                  controller: provider.confirmController,
                  isPassword: true,
                  isObscured: provider.confirmObscured,
                  onToggleObscure: provider.toggleConfirmObscured,
                ),

                if (state is UiError) ...[
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.error,
                    ),
                  ),
                ],
                if (state is UiSuccess) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Tu contraseña se actualizó correctamente.',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.accent,
                    ),
                  ),
                ],

                const SizedBox(height: 40),

                PrimaryAuthButton(
                  text: 'Guardar cambios',
                  isLoading: state is UiLoading,
                  onPressed: () async {
                    await provider.submit();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
