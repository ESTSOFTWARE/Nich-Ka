import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import '../../../../core/presentation/change_notifier_provider.dart';
import '../../../../core/presentation/responsive.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../../home/presentation/components/home_glow.dart';
import '../../domain/entities/class_detail.dart';
import '../../domain/entities/class_member.dart';
import '../components/class_detail_hero_card.dart';
import '../components/class_detail_stats_row.dart';
import '../components/class_fermentation_item.dart';
import '../components/class_members_row.dart';
import '../components/class_teacher_card.dart';
import '../providers/class_detail_provider.dart';
import '../theme/class_palette.dart';
import '../../../../core/presentation/tablet_text_scale.dart';

class ClassDetailView extends StatelessWidget {
  final ClassDetail detail;

  const ClassDetailView({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ClassDetailProvider>(
      create: () => ClassDetailProvider(detail),
      builder: (context, provider) {
        final isDark = AppThemeScope.of(context).isDark;
        final palette = ClassPalette.of(isDark);
        final homePalette = AppPalette.of(isDark);

        return Scaffold(
          backgroundColor: palette.background,
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
              (kToolbarHeight) * (isTablet(context) ? kTabletHeaderScale : 1.0),
            ),
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: provider.isScrolled ? 20 : 0,
                  sigmaY: provider.isScrolled ? 20 : 0,
                ),
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(
                      isTablet(context) ? kTabletTextScale : 1,
                    ),
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
                        onTap: () => context.canPop()
                            ? context.pop()
                            : context.go('/classes'),
                        child: Container(
                          width: 36,
                          height: 36,
                          margin: const EdgeInsets.only(left: 16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: palette.border),
                          ),
                          child: Icon(
                            Icons.chevron_left,
                            color: palette.textPrimary,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      'Detalle de clase',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: palette.textPrimary,
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
                            border: Border.all(color: palette.border),
                          ),
                          child: Icon(
                            Icons.more_horiz,
                            color: palette.textPrimary,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: TabletTextScale(
            child: Stack(
              children: [
                HomeGlow(palette: homePalette),
                SingleChildScrollView(
                  controller: provider.scrollController,
                  padding: EdgeInsets.fromLTRB(
                    16,
                    MediaQuery.of(context).padding.top +
                        (kToolbarHeight + 8) *
                            (isTablet(context) ? kTabletHeaderScale : 1.0),
                    16,
                    MediaQuery.of(context).padding.bottom + 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClassDetailHeroCard(
                        badgeLabel: provider.detail.badgeLabel,
                        coverImage: provider.detail.coverImage,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        provider.detail.subject,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: ClassPalette.accent,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        provider.detail.name,
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: palette.textPrimary,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (isTablet(context) && isLandscape(context))
                        // Tablet horizontal: info de la clase a la izquierda,
                        // fermentaciones a la derecha. En vertical se apila
                        // igual que en el teléfono.
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _infoColumn(context, provider, palette),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _fermentationsSection(
                                context,
                                provider,
                                palette,
                              ),
                            ),
                          ],
                        )
                      else ...[
                        _infoColumn(context, provider, palette),
                        const SizedBox(height: 24),
                        _fermentationsSection(context, provider, palette),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Stats + card del profesor + compañeros.
  Widget _infoColumn(
    BuildContext context,
    ClassDetailProvider provider,
    ClassPalette palette,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClassDetailStatsRow(
          studentCount: provider.detail.studentCount,
          createdAt: provider.detail.createdAt,
          palette: palette,
        ),
        const SizedBox(height: 16),
        ClassTeacherCard(
          name: provider.detail.teacherName,
          email: provider.detail.teacherEmail,
          initials: provider.detail.teacherInitials,
          avatarColor: provider.detail.teacherAvatarColor,
          avatar: provider.detail.teacherAvatar,
          palette: palette,
          onTapProfile: () => _openTeacherDetail(context, provider),
          onTapEmail: () => _openMailTo(provider.detail.teacherEmail),
        ),
        const SizedBox(height: 20),
        ClassMembersRow(
          members: provider.detail.members,
          totalMembers: provider.detail.totalMembers,
          palette: palette,
          onViewAll: () => context.push(
            '/class-members',
            extra: {
              'className': provider.detail.name,
              'members': provider.detail.members,
            },
          ),
        ),
      ],
    );
  }

  /// Encabezado "Fermentaciones de la clase" + lista navegable.
  Widget _fermentationsSection(
    BuildContext context,
    ClassDetailProvider provider,
    ClassPalette palette,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Fermentaciones de la clase',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
            ),
            Text(
              '${provider.fermentations.length}',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: palette.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: palette.border),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.fermentations.length,
            separatorBuilder: (_, _) =>
                Divider(color: palette.border, height: 1),
            itemBuilder: (_, i) => ClassFermentationItem(
              fermentation: provider.fermentations[i],
              palette: palette,
              onTap: () {
                final f = provider.fermentations[i];
                // En curso → overview en vivo; terminada → reporte.
                if (f.isActive) {
                  context.push('/overview');
                } else {
                  context.push('/report-detail', extra: f.sessionId);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Abre el detalle de usuario del docente (misma vista que un miembro).
  void _openTeacherDetail(BuildContext context, ClassDetailProvider provider) {
    final d = provider.detail;
    if (d.teacherId == null) return;
    context.push(
      '/user-detail',
      extra: ClassMember(
        id: d.teacherId!,
        initials: d.teacherInitials,
        color: d.teacherAvatarColor,
        name: d.teacherName,
        email: d.teacherEmail,
        avatar: d.teacherAvatar,
      ),
    );
  }

  /// Abre el cliente de correo con el destinatario ya puesto.
  Future<void> _openMailTo(String email) async {
    if (email.isEmpty) return;
    final uri = Uri(scheme: 'mailto', path: email);
    try {
      await launchUrl(uri);
    } catch (_) {
      /* sin cliente de correo instalado: no hay nada que abrir */
    }
  }
}
