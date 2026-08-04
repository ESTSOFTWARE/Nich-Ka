import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/components/circle_icon_button.dart';
import '../notifiers/profile_notifier.dart';
import '../notifiers/profile_state.dart';
import '../theme/profile_palette.dart';
import '../components/profile_header_card.dart';
import '../components/profile_section.dart';
import '../components/profile_info_row.dart';
import '../components/profile_tile_row.dart';
import '../components/theme_mode_selector.dart';
import '../components/top_glow.dart';
import '../states/ui_state.dart';
import '../../domain/entities/profile_user.dart';
import '../../../../core/presentation/responsive_center.dart';
import '../../../../core/presentation/tablet_text_scale.dart';
import '../../../../core/validation/input_formatters.dart';

part 'profile_view_chip.dart';
part 'profile_view_inline_row.dart';
part 'profile_view_inline_phone_row.dart';
part 'profile_view_inline_desc_row.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileProvider);
    final notifier = ref.read(profileProvider.notifier);
    final isDark = AppThemeScope.of(context).isDark;
    final palette = ProfilePalette.of(isDark);
    final profileUi = state.profileState;

    if (state.uploadError != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.uploadError!),
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
            child: switch (profileUi) {
              UiLoading() => _buildLoading(palette),
              UiError e => _buildError(palette, e, notifier),
              UiSuccess s => _buildContent(
                context,
                state,
                notifier,
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
  }

  Widget _buildLoading(ProfilePalette palette) => Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(ProfilePalette.accent),
    ),
  );

  Widget _buildError(
    ProfilePalette palette,
    UiError<dynamic> error,
    ProfileNotifier notifier,
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
              onPressed: notifier.loadProfile,
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
    ProfileState state,
    ProfileNotifier notifier,
    ProfileUser user,
    bool isDark,
    ProfilePalette palette,
  ) {
    final editing = state.editingInfo;

    return TabletTextScale(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── App bar ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                CircleIconButton(
                  icon: Icons.arrow_back_ios_new,
                  backgroundColor: palette.surface,
                  borderColor: palette.border,
                  iconColor: editing ? palette.textMuted : palette.textPrimary,
                  onTap: editing
                      ? () {}
                      : () => context.canPop()
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
                if (!editing)
                  _Chip(
                    label: 'Editar',
                    icon: Icons.edit_outlined,
                    color: palette.textSecondary,
                    borderColor: palette.border,
                    onTap: notifier.startEditing,
                  )
                else ...[
                  _Chip(
                    label: 'Cancelar',
                    color: palette.textMuted,
                    borderColor: palette.border,
                    onTap: notifier.cancelEditing,
                  ),
                  const SizedBox(width: 8),
                  _Chip(
                    label: state.isSaving ? 'Guardando…' : 'Guardar',
                    color: ProfilePalette.accent,
                    borderColor: ProfilePalette.accent,
                    onTap: state.isSaving
                        ? null
                        : () async {
                            final ok = await notifier.saveEditing();
                            if (ok && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Perfil actualizado'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                  ),
                ],
              ],
            ),
          ),

          // ── Cuerpo ───────────────────────────────────────────────
          Expanded(
            child: ResponsiveCenter(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileHeaderCard(
                      user: user,
                      palette: palette,
                      onChangePhoto: state.isUploading
                          ? null
                          : notifier.pickAndUploadPhoto,
                      isUploading: state.isUploading,
                    ),
                    const SizedBox(height: 28),

                    // ── Sección Información ─────────────────────────
                    ProfileSection(
                      title: 'Información',
                      palette: palette,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: editing
                            ? [
                                _InlineRow(
                                  label: 'Nombre',
                                  controller: notifier.nameCtrl,
                                  palette: palette,
                                ),
                                _divider(palette),
                                _InlineRow(
                                  label: 'Apellido',
                                  controller: notifier.lastNameCtrl,
                                  palette: palette,
                                ),
                                _divider(palette),
                                _InlinePhoneRow(
                                  controller: notifier.phoneCtrl,
                                  dialCode: state.dialCode,
                                  palette: palette,
                                  onDialCodeTap: () =>
                                      _pickDialCode(context, state, notifier),
                                ),
                                _divider(palette),
                                _InlineDescRow(
                                  controller: notifier.descriptionCtrl,
                                  palette: palette,
                                ),
                              ]
                            : [
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
                                  label: 'Teléfono',
                                  value: (user.phoneNumber?.isNotEmpty ?? false)
                                      ? '${user.dialCode ?? ''} ${user.phoneNumber!}'
                                            .trim()
                                      : 'Sin teléfono',
                                  palette: palette,
                                ),
                                ProfileInfoRow(
                                  label: 'Descripción',
                                  value: (user.description?.isNotEmpty ?? false)
                                      ? user.description!
                                      : 'Sin descripción',
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

                    if (!editing) ...[
                      const SizedBox(height: 24),
                      ProfileSection(
                        title: 'Apariencia',
                        palette: palette,
                        child: ThemeModeSelector(
                          choice: AppThemeScope.of(context).choice,
                          surface: palette.surface,
                          border: palette.border,
                          textMuted: palette.textMuted,
                          textSecondary: palette.textSecondary,
                          onChanged: AppThemeScope.of(context).setChoice,
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
                            state.isGoogleLinked ? 'Conectado' : 'Vincular',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: state.isGoogleLinked
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
                            Uri.parse(
                              'https://www.nich-ka.space/delete-account',
                            ),
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(ProfilePalette palette) =>
      Divider(height: 1, thickness: 1, color: palette.border);

  void _pickDialCode(
    BuildContext context,
    ProfileState state,
    ProfileNotifier notifier,
  ) {
    const codes = ['+52', '+1', '+34', '+57', '+54', '+56', '+51', '+58'];
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 8),
          ...codes.map(
            (c) => ListTile(
              title: Text(c, style: GoogleFonts.poppins(fontSize: 14)),
              trailing: c == state.dialCode
                  ? Icon(Icons.check, color: ProfilePalette.accent)
                  : null,
              onTap: () {
                notifier.setDialCode(c);
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Widgets locales ────────────────────────────────────────────────────────────

/// Fila editable inline (una línea) — mismo aspecto que ProfileInfoRow.

/// Fila de teléfono inline con selector de código de país.

/// Fila de descripción inline (multi-línea).
