import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import '../../../../core/presentation/change_notifier_provider.dart';
import '../../../../shared/components/circle_icon_button.dart';
import '../providers/profile_provider.dart';
import '../theme/profile_palette.dart';
import '../components/profile_header_card.dart';
import '../components/profile_section.dart';
import '../components/profile_info_row.dart';
import '../components/profile_tile_row.dart';
import '../components/theme_toggle.dart';
import '../components/top_glow.dart';
import '../components/edit_button.dart';
import '../states/ui_state.dart';
import '../../domain/entities/profile_user.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileProvider>(
      create: () => ProfileProvider(),
      builder: (context, provider) {
        final isDark = AppThemeScope.of(context).isDark;
        final palette = ProfilePalette.of(isDark);
        final state = provider.state;

        if (provider.uploadError != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(provider.uploadError!),
                backgroundColor: Colors.red.shade700,
                behavior: SnackBarBehavior.floating,
              ),
            );
          });
        }

        return Scaffold(
          backgroundColor: palette.background,
          body: Stack(
            children: [
              TopGlow(isDark: isDark),
              SafeArea(
                child: switch (state) {
                  UiLoading() => _buildLoading(palette),
                  UiError e => _buildError(palette, e, provider),
                  UiSuccess s => _buildContent(
                    context,
                    provider,
                    s.data,
                    isDark,
                    palette,
                  ),
                  _ => const SizedBox.shrink(),
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoading(ProfilePalette palette) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(ProfilePalette.accent),
      ),
    );
  }

  Widget _buildError(
    ProfilePalette palette,
    UiError<dynamic> error,
    ProfileProvider provider,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: palette.textMuted),
            const SizedBox(height: 16),
            Text(
              error.message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: palette.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: provider.loadProfile,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: ProfilePalette.accent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: Text(
                'Reintentar',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: ProfilePalette.accent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ProfileProvider provider,
    ProfileUser user,
    bool isDark,
    ProfilePalette palette,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: [
              CircleIconButton(
                icon: Icons.arrow_back_ios_new,
                backgroundColor: palette.surface,
                borderColor: palette.border,
                iconColor: palette.textPrimary,
                onTap: () => context.canPop()
                    ? context.pop()
                    : context.go('/login-email'),
              ),
              const SizedBox(width: 14),
              Text(
                'Mi perfil',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: palette.textPrimary,
                ),
              ),
              const Spacer(),
              EditButton(palette: palette, onTap: () {}),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileHeaderCard(
                  user: user,
                  palette: palette,
                  onChangePhoto: provider.isUploading
                      ? null
                      : provider.pickAndUploadPhoto,
                  isUploading: provider.isUploading,
                ),
                const SizedBox(height: 28),
                ProfileSection(
                  title: 'Información',
                  palette: palette,
                  child: Column(
                    children: [
                      ProfileInfoRow(
                        label: 'Nombre',
                        value: user.firstName,
                        palette: palette,
                      ),
                      ProfileInfoRow(
                        label: 'Apellido',
                        value: user.lastName,
                        palette: palette,
                      ),
                      ProfileInfoRow(
                        label: 'Correo',
                        value: user.email,
                        palette: palette,
                      ),
                      ProfileInfoRow(
                        label: 'Circuito',
                        value: user.circuit,
                        palette: palette,
                      ),
                      ProfileInfoRow(
                        label: 'Miembro desde',
                        value: user.memberSince,
                        palette: palette,
                        showDivider: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ProfileSection(
                  title: 'Apariencia',
                  palette: palette,
                  child: ProfileTileRow(
                    title: 'Tema',
                    palette: palette,
                    trailing: ThemeToggle(
                      isDark: isDark,
                      palette: palette,
                      onChanged: AppThemeScope.of(context).setDark,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ProfileSection(
                  title: 'Cuentas vinculadas',
                  palette: palette,
                  child: ProfileTileRow(
                    iconPath: 'assets/icons/google.svg',
                    title: 'Google',
                    palette: palette,
                    trailing: Text(
                      provider.isGoogleLinked ? 'Conectado' : 'Vincular',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: provider.isGoogleLinked
                            ? ProfilePalette.accent
                            : palette.textSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ProfileSection(
                  title: 'Seguridad',
                  palette: palette,
                  child: ProfileTileRow(
                    title: 'Cambiar contraseña',
                    palette: palette,
                    onTap: () => context.push('/change-password'),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: palette.textMuted,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => launchUrl(
                      Uri.parse('https://www.nich-ka.space/delete-account'),
                      mode: LaunchMode.externalApplication,
                    ),
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Colors.red,
                    ),
                    label: Text(
                      'Eliminar cuenta',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
