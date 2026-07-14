import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../../home/presentation/components/home_glow.dart';
import '../../domain/entities/class_detail.dart';
import '../components/class_detail_hero_card.dart';
import '../components/class_detail_stats_row.dart';
import '../components/class_fermentation_item.dart';
import '../components/class_members_row.dart';
import '../components/class_teacher_card.dart';
import '../notifiers/class_detail_notifier.dart';
import '../notifiers/class_detail_state.dart';
import '../states/ui_state.dart';
import '../theme/class_palette.dart';

class ClassDetailView extends ConsumerStatefulWidget {
  final ClassDetail detail;

  const ClassDetailView({super.key, required this.detail});

  @override
  ConsumerState<ClassDetailView> createState() => _ClassDetailViewState();
}

class _ClassDetailViewState extends ConsumerState<ClassDetailView> {
  final _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = _scrollController.offset > 4;
    if (scrolled != _isScrolled) {
      setState(() => _isScrolled = scrolled);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detail = widget.detail;
    final detailState = ref.watch(classDetailProvider(detail.id));
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
              sigmaX: _isScrolled ? 20 : 0,
              sigmaY: _isScrolled ? 20 : 0,
            ),
            child: AppBar(
              backgroundColor: _isScrolled
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
                  onTap: () =>
                      context.canPop() ? context.pop() : context.go('/classes'),
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
      body: Stack(
        children: [
          HomeGlow(palette: homePalette),
          SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.fromLTRB(
              16,
              MediaQuery.of(context).padding.top + kToolbarHeight + 8,
              16,
              MediaQuery.of(context).padding.bottom + 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClassDetailHeroCard(
                  badgeLabel: detail.badgeLabel,
                  coverImage: detail.coverImage,
                ),
                const SizedBox(height: 20),
                Text(
                  detail.subject,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: ClassPalette.accent,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail.name,
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: palette.textPrimary,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 16),
                ClassDetailStatsRow(
                  studentCount: detail.studentCount,
                  createdAt: detail.createdAt,
                  palette: palette,
                ),
                const SizedBox(height: 16),
                ClassTeacherCard(
                  name: detail.teacherName,
                  email: detail.teacherEmail,
                  initials: detail.teacherInitials,
                  avatarColor: detail.teacherAvatarColor,
                  avatar: detail.teacherAvatar,
                  palette: palette,
                ),
                const SizedBox(height: 20),
                ClassMembersRow(
                  members: detail.members,
                  totalMembers: detail.totalMembers,
                  palette: palette,
                  onViewAll: () => context.push(
                    '/class-members',
                    extra: {
                      'className': detail.name,
                      'members': detail.members,
                    },
                  ),
                ),
                const SizedBox(height: 24),
                _buildFermentationsSection(detailState, detail, palette),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFermentationsSection(
    ClassDetailState detailState,
    ClassDetail detail,
    ClassPalette palette,
  ) {
    final fermentations = switch (detailState.fermentationsState) {
      UiSuccess(:final data) => data,
      _ => <dynamic>[],
    };

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
              '${fermentations.length}',
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
            itemCount: fermentations.length,
            separatorBuilder: (_, _) =>
                Divider(color: palette.border, height: 1),
            itemBuilder: (_, i) => ClassFermentationItem(
              fermentation: fermentations[i],
              palette: palette,
            ),
          ),
        ),
      ],
    );
  }
}
