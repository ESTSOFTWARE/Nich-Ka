import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import '../../domain/entities/class_detail.dart';
import '../../../../core/presentation/change_notifier_provider.dart';
import '../../../home/presentation/components/home_glow.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../domain/entities/class_item.dart';
import '../../domain/entities/class_summary.dart';
import '../components/class_card.dart';
import '../components/classes_error_state.dart';
import '../components/classes_skeleton.dart';
import '../components/empty_classes_state.dart';
import '../providers/class_list_provider.dart';
import '../states/ui_state.dart';
import '../theme/class_palette.dart';

class ClassListView extends StatelessWidget {
  const ClassListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ClassListProvider>(
      create: () => ClassListProvider(),
      builder: (context, provider) {
        final isDark = AppThemeScope.of(context).isDark;
        final palette = ClassPalette.of(isDark);
        final homePalette = AppPalette.of(isDark);

        final subtitle = switch (provider.summaryState) {
          UiSuccess<ClassSummary>(:final data) =>
            '${data.totalGroups} grupos · ${data.unreadItems} elementos sin leer',
          _ => 'Cargando...',
        };

        return Scaffold(
          backgroundColor: palette.background,
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(64),
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
                  toolbarHeight: 64,
                  leadingWidth: 56,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: GestureDetector(
                      onTap: () => context.canPop()
                          ? context.pop()
                          : context.go('/home'),
                      child: Container(
                        width: 36,
                        height: 36,
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
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mis clases',
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: _buildJoinButton(
                        () => context.push('/class'),
                        palette,
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
              RefreshIndicator(
                color: ClassPalette.accent,
                backgroundColor: palette.surface,
                onRefresh: provider.refresh,
                child: SingleChildScrollView(
                  controller: provider.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    16,
                    MediaQuery.of(context).padding.top + 64 + 16,
                    16,
                    24,
                  ),
                  child: _buildContent(context, provider, palette),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildJoinButton(VoidCallback onTap, ClassPalette palette) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: ClassPalette.accent.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ClassPalette.accent.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add, size: 16, color: ClassPalette.accent),
            const SizedBox(width: 6),
            Text(
              'Unirme',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: ClassPalette.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ClassListProvider provider,
    ClassPalette palette,
  ) {
    return switch (provider.classesState) {
      UiLoading<List<ClassItem>>() => ClassesSkeleton(palette: palette),
      UiError<List<ClassItem>>(:final message) => ClassesErrorState(
        message: message,
        palette: palette,
        onRetry: provider.refresh,
      ),
      UiSuccess<List<ClassItem>>(:final data) when data.isEmpty =>
        EmptyClassesState(
          palette: palette,
          onJoinClass: () => context.push('/class'),
        ),
      UiSuccess<List<ClassItem>>(:final data) => _buildList(
        context,
        data,
        palette,
      ),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildList(
    BuildContext context,
    List<ClassItem> items,
    ClassPalette palette,
  ) {
    return Column(
      children: items.map((item) {
        final isLast = item == items.last;
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
          child: ClassCard(
            item: item,
            palette: palette,
            onTap: () => context.push(
              '/class-detail',
              extra: ClassDetail.fromItem(item),
            ),
          ),
        );
      }).toList(),
    );
  }
}
