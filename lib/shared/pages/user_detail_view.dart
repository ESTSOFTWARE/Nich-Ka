import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/presentation/app_theme_scope.dart';
import '../../core/presentation/change_notifier_provider.dart';
import '../../core/presentation/ui_state.dart';
import '../../features/class/domain/entities/class_member.dart';
import '../../features/class/presentation/components/class_stat_tile.dart';
import '../../features/class/presentation/theme/class_palette.dart';
import '../../features/home/presentation/components/home_glow.dart';
import '../../features/profile/data/datasource/remote/model/dto/response/user_profile_dto.dart';
import '../../shared/theme/app_palette.dart';
import '../providers/user_detail_provider.dart';
import '../../core/presentation/responsive_center.dart';

class UserDetailView extends StatelessWidget {
  final ClassMember member;

  const UserDetailView({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserDetailProvider>(
      create: () => UserDetailProvider(member),
      builder: (context, provider) {
        final isDark = AppThemeScope.of(context).isDark;
        final palette = ClassPalette.of(isDark);
        final homePalette = AppPalette.of(isDark);

        return Scaffold(
          backgroundColor: palette.background,
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: provider.isScrolled ? 20 : 0,
                  sigmaY: provider.isScrolled ? 20 : 0,
                ),
                child: AppBar(
                  backgroundColor: provider.isScrolled
                      ? homePalette.glassBackground
                      : Colors.transparent,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  systemOverlayStyle: isDark
                      ? SystemUiOverlayStyle.light
                      : SystemUiOverlayStyle.dark,
                  automaticallyImplyLeading: false,
                  centerTitle: false,
                  leadingWidth: 56,
                  leading: Center(
                    child: GestureDetector(
                      onTap: () => context.canPop() ? context.pop() : null,
                      child: Container(
                        width: 36,
                        height: 36,
                        margin: const EdgeInsets.only(left: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: provider.isScrolled
                                ? palette.border
                                : Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Icon(
                          Icons.chevron_left,
                          color: provider.isScrolled
                              ? palette.textPrimary
                              : Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    'Detalle de usuario',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: provider.isScrolled
                          ? palette.textPrimary
                          : Colors.white,
                    ),
                  ),
                  actions: [
                    Center(
                      child: Container(
                        width: 36,
                        height: 36,
                        margin: const EdgeInsets.only(right: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: provider.isScrolled
                                ? palette.border
                                : Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Icon(
                          Icons.more_horiz,
                          color: provider.isScrolled
                              ? palette.textPrimary
                              : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              HomeGlow(palette: homePalette),
              _buildBody(context, provider, palette),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    UserDetailProvider provider,
    ClassPalette palette,
  ) {
    return switch (provider.userState) {
      UiLoading() => Center(
        child: CircularProgressIndicator(color: ClassPalette.accent),
      ),
      UiError(:final message) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: palette.textMuted),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
      UiSuccess(:final data) => _buildContent(context, provider, data, palette),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildContent(
    BuildContext context,
    UserDetailProvider provider,
    UserProfileDto dto,
    ClassPalette palette,
  ) {
    final fullName = dto.fullName.trim();
    final displayName = fullName.isNotEmpty ? fullName : member.name;
    final displayAvatar = dto.profileImage ?? member.avatar;
    final role = dto.role.isNotEmpty ? dto.role : 'Sin rol';

    return ResponsiveCenter(
      child: SingleChildScrollView(
        controller: provider.scrollController,
        padding: EdgeInsets.fromLTRB(
          16,
          MediaQuery.of(context).padding.top + kToolbarHeight + 8,
          16,
          MediaQuery.of(context).padding.bottom + 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroCard(context, provider, palette, displayAvatar),
            const SizedBox(height: 16),
            Text(
              role.toUpperCase(),
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: ClassPalette.accent,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    displayName,
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: palette.textPrimary,
                      height: 1.15,
                    ),
                  ),
                ),
                if (dto.role == 'admin') ...[
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    'assets/icons/verified.svg',
                    width: 24,
                    height: 24,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            _buildDescriptionCard(palette, dto),
            const SizedBox(height: 16),
            _buildStatsRow(palette, dto),
            const SizedBox(height: 16),
            _buildInfoCard(palette, dto, displayName),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(
    BuildContext context,
    UserDetailProvider provider,
    ClassPalette palette,
    String? avatarUrl,
  ) {
    final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;
    final heroHeight = 180.0;

    return GestureDetector(
      onTap: hasAvatar
          ? () => provider.openImageViewer(context, avatarUrl)
          : null,
      child: Container(
        height: heroHeight,
        width: double.infinity,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              member.color.withValues(alpha: 0.6),
              member.color.withValues(alpha: 0.15),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              right: -40,
              top: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                    width: 40,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 20,
              bottom: -60,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.04),
                    width: 30,
                  ),
                ),
              ),
            ),
            Center(
              child: hasAvatar
                  ? Container(
                      width: 154,
                      height: 154,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.5),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          avatarUrl,
                          width: 148,
                          height: 148,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) =>
                              _heroInitials(),
                        ),
                      ),
                    )
                  : _heroInitials(),
            ),
            Positioned(
              top: 14,
              right: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                child: Text(
                  'MIEMBRO',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _heroInitials() {
    return Container(
      width: 150,
      height: 150,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Text(
        member.initials,
        style: GoogleFonts.poppins(
          fontSize: 50,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildStatsRow(ClassPalette palette, UserProfileDto dto) {
    String memberSince = '';
    if (dto.createdAt != null) {
      try {
        final date = DateTime.parse(dto.createdAt!);
        const months = [
          'ene',
          'feb',
          'mar',
          'abr',
          'may',
          'jun',
          'jul',
          'ago',
          'sep',
          'oct',
          'nov',
          'dic',
        ];
        memberSince = '${date.day} ${months[date.month - 1]} ${date.year}';
      } catch (_) {
        memberSince = dto.createdAt!;
      }
    }

    return Row(
      children: [
        ClassStatTile(
          icon: Icons.badge_outlined,
          label: 'ROL',
          value: dto.role.isNotEmpty ? dto.role : 'Sin rol',
          palette: palette,
        ),
        const SizedBox(width: 10),
        ClassStatTile(
          icon: Icons.calendar_today_outlined,
          label: 'SE UNIÓ',
          value: memberSince.isNotEmpty ? memberSince : 'Sin fecha',
          palette: palette,
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    ClassPalette palette,
    UserProfileDto dto,
    String displayName,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: Text(
              'INFORMACIÓN',
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: palette.textMuted,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            palette: palette,
            icon: Icons.person_outline,
            label: 'Nombre',
            value: displayName,
          ),
          Divider(color: palette.border, height: 1),
          _buildInfoRow(
            palette: palette,
            icon: Icons.email_outlined,
            label: 'Correo',
            value: dto.email.isNotEmpty ? dto.email : 'Sin correo',
            valueColor: dto.email.isNotEmpty
                ? ClassPalette.accent
                : palette.textMuted,
          ),
          Divider(color: palette.border, height: 1),
          _buildInfoRow(
            palette: palette,
            icon: Icons.phone_outlined,
            label: 'Teléfono',
            value: (dto.phoneNumber?.isNotEmpty ?? false)
                ? '${dto.dialCode ?? ''} ${dto.phoneNumber!}'.trim()
                : 'Sin teléfono',
            valueColor: (dto.phoneNumber?.isNotEmpty ?? false)
                ? palette.textPrimary
                : palette.textMuted,
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard(ClassPalette palette, UserProfileDto dto) {
    final text = (dto.description?.isNotEmpty ?? false)
        ? dto.description!
        : 'Sin descripción';
    final hasDesc = dto.description?.isNotEmpty ?? false;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DESCRIPCIÓN',
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: palette.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: hasDesc ? palette.textPrimary : palette.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required ClassPalette palette,
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: palette.textMuted),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: palette.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: valueColor ?? palette.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
