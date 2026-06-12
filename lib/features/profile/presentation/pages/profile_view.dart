import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/change_notifier_provider.dart';
import '../../../../shared/widgets/circle_icon_button.dart';
import '../providers/profile_provider.dart';
import '../theme/profile_palette.dart';
import '../components/profile_header_card.dart';
import '../components/profile_section.dart';
import '../components/profile_info_row.dart';
import '../components/profile_tile_row.dart';
import '../components/theme_toggle.dart';
import '../components/top_glow.dart';
import '../components/edit_button.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileProvider>(
      create: () => ProfileProvider(),
      builder: (context, provider) {
        final palette = provider.palette;
        final user = provider.user;

        return Scaffold(
          backgroundColor: palette.background,
          body: Stack(
            children: [
              TopGlow(isDark: provider.isDarkMode),
              SafeArea(
                child: Column(
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
                            ProfileHeaderCard(user: user, palette: palette),
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
                                  isDark: provider.isDarkMode,
                                  palette: palette,
                                  onChanged: provider.setDarkMode,
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
                                  provider.isGoogleLinked
                                      ? 'Conectado'
                                      : 'Vincular',
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
