import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/fermentation_detail_chart_card.dart';
import '../components/fermentation_detail_metrics_grid.dart';
import '../components/fermentation_detail_status_card.dart';
import '../components/fermentation_events_section.dart';
import '../components/fermentation_info_banner.dart';
import '../notifiers/fermentation_detail_notifier.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../../home/presentation/components/home_glow.dart';
import '../../../../core/presentation/responsive_center.dart';
import '../../../../core/presentation/responsive.dart';

class FermentationDetailView extends ConsumerWidget {
  const FermentationDetailView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fermentationDetailProvider);
    final notifier = ref.read(fermentationDetailProvider.notifier);
    final isDark = AppThemeScope.of(context).isDark;
    final palette = AppPalette.of(isDark);
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
              sigmaX: state.isScrolled ? 20 : 0,
              sigmaY: state.isScrolled ? 20 : 0,
            ),
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(
                  isTablet(context) ? kTabletTextScale : 1,
                ),
              ),
              child: AppBar(
                backgroundColor: state.isScrolled
                    ? palette.glassBackground
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
                        : context.go('/fermentations'),
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
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.detail.title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: palette.textPrimary,
                      ),
                    ),
                    Text(
                      state.detail.subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
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
      body: Stack(
        children: [
          HomeGlow(palette: palette),
          ResponsiveCenter(
            child: SingleChildScrollView(
              controller: notifier.scrollController,
              padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.of(context).padding.top +
                    (kToolbarHeight + 8) *
                        (isTablet(context) ? kTabletHeaderScale : 1.0),
                16,
                32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FermentationDetailStatusCard(
                    detail: state.detail,
                    palette: palette,
                  ),
                  const SizedBox(height: 12),
                  FermentationDetailChartCard(
                    points: state.detail.chartPoints,
                    palette: palette,
                  ),
                  const SizedBox(height: 12),
                  FermentationDetailMetricsGrid(
                    detail: state.detail,
                    palette: palette,
                  ),
                  const SizedBox(height: 12),
                  FermentationInfoBanner(palette: palette),
                  const SizedBox(height: 24),
                  FermentationEventsSection(
                    events: state.detail.events,
                    palette: palette,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
