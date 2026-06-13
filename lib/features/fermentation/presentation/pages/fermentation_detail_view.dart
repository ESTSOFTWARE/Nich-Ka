import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import '../../../../core/presentation/change_notifier_provider.dart';
import '../components/fermentation_detail_chart_card.dart';
import '../components/fermentation_detail_metrics_grid.dart';
import '../components/fermentation_detail_status_card.dart';
import '../components/fermentation_events_section.dart';
import '../components/fermentation_info_banner.dart';
import '../providers/fermentation_detail_provider.dart';
import '../../../home/presentation/theme/home_palette.dart';

class FermentationDetailView extends StatelessWidget {
  const FermentationDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FermentationDetailProvider>(
      create: () => FermentationDetailProvider(),
      builder: (context, provider) {
        final isDark = AppThemeScope.of(context).isDark;
        final palette = HomePalette.of(isDark);
        return Scaffold(
          backgroundColor: palette.background,
          appBar: AppBar(
            backgroundColor: palette.background,
            elevation: 0,
            scrolledUnderElevation: 0,
            systemOverlayStyle: isDark
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
            automaticallyImplyLeading: false,
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
                  provider.detail.title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: palette.textPrimary,
                  ),
                ),
                Text(
                  provider.detail.subtitle,
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
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FermentationDetailStatusCard(
                  detail: provider.detail,
                  palette: palette,
                ),
                const SizedBox(height: 12),
                FermentationDetailChartCard(
                  points: provider.detail.chartPoints,
                  palette: palette,
                ),
                const SizedBox(height: 12),
                FermentationDetailMetricsGrid(
                  detail: provider.detail,
                  palette: palette,
                ),
                const SizedBox(height: 12),
                FermentationInfoBanner(palette: palette),
                const SizedBox(height: 24),
                FermentationEventsSection(
                  events: provider.detail.events,
                  palette: palette,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
