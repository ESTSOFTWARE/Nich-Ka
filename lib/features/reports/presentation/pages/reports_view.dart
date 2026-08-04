import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/home/presentation/components/home_glow.dart';
import '../../../../shared/theme/app_palette.dart';
import '../components/report_summary_cards.dart';
import '../components/reports_empty_state.dart';
import '../components/reports_error_state.dart';
import '../components/reports_filter_bar.dart';
import '../components/reports_list.dart';
import '../components/reports_skeleton.dart';
import '../../domain/entities/report_item.dart';
import '../../domain/entities/reports_summary.dart';
import '../notifiers/reports_notifier.dart';
import '../states/ui_state.dart';
import '../theme/reports_palette.dart';
import '../../../../core/presentation/responsive_center.dart';
import '../../../../core/presentation/responsive.dart';

class ReportsView extends ConsumerWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = AppThemeScope.of(context).isDark;
    final palette = ReportsPalette.of(isDark);
    final homePalette = AppPalette.of(isDark);

    _handleDownloadSnackbar(context, ref);

    return Scaffold(
      key: ref.read(reportsProvider.notifier).scaffoldKey,
      backgroundColor: palette.background,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          (kToolbarHeight) * (isTablet(context) ? kTabletHeaderScale : 1.0),
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: ref.watch(reportsProvider).isScrolled ? 20 : 0,
              sigmaY: ref.watch(reportsProvider).isScrolled ? 20 : 0,
            ),
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(
                  isTablet(context) ? kTabletTextScale : 1,
                ),
              ),
              child: AppBar(
                backgroundColor: ref.watch(reportsProvider).isScrolled
                    ? homePalette.glassBackground
                    : Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                automaticallyImplyLeading: false,
                titleSpacing: 16,
                title: Row(
                  children: [
                    _buildBackButton(context, palette),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTitle(ref, palette)),
                    _buildFilterButton(palette),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          HomeGlow(palette: homePalette),
          RefreshIndicator(
            color: ReportsPalette.accent,
            backgroundColor: palette.surface,
            onRefresh: ref.read(reportsProvider.notifier).refresh,
            child: ResponsiveCenter(
              child: SingleChildScrollView(
                controller: ref.read(reportsProvider.notifier).scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  16,
                  MediaQuery.of(context).padding.top +
                      (kToolbarHeight + 16) *
                          (isTablet(context) ? kTabletHeaderScale : 1.0),
                  16,
                  24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReportsFilterBar(
                      selected: ref.watch(reportsProvider).selectedFilter,
                      palette: palette,
                      onSelected: ref
                          .read(reportsProvider.notifier)
                          .selectFilter,
                    ),
                    const SizedBox(height: 16),
                    _buildSummary(ref, palette),
                    const SizedBox(height: 16),
                    _buildList(context, ref, palette),
                  ],
                ),
              ),
            ),
          ),
          if (ref.watch(reportsProvider).isDownloading)
            _buildDownloadOverlay(palette),
        ],
      ),
    );
  }

  void _handleDownloadSnackbar(BuildContext context, WidgetRef ref) {
    if (ref.watch(reportsProvider).downloadError != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ref.watch(reportsProvider).downloadError!),
            backgroundColor: Colors.red,
          ),
        );
        ref.read(reportsProvider.notifier).clearDownloadFlags();
      });
    } else if (ref.watch(reportsProvider).downloadCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('PDF descargado correctamente.'),
            backgroundColor: Colors.green,
          ),
        );
        ref.read(reportsProvider.notifier).clearDownloadFlags();
      });
    }
  }

  Widget _buildDownloadOverlay(ReportsPalette palette) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 24,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: palette.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: ReportsPalette.accent,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Descargando PDF...',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: palette.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static int? _extractSessionId(String reportId) {
    final id = reportId.replaceFirst('F-', '');
    return int.tryParse(id);
  }

  Widget _buildBackButton(BuildContext context, ReportsPalette palette) {
    return InkWell(
      onTap: () => context.canPop() ? context.pop() : context.go('/home'),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: palette.textSecondary.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: Icon(Icons.chevron_left, color: palette.textPrimary, size: 26),
      ),
    );
  }

  Widget _buildFilterButton(ReportsPalette palette) {
    return InkWell(
      onTap: () {
        // TODO: abrir filtros
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: palette.textSecondary.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: Icon(Icons.filter_list, color: palette.textPrimary, size: 22),
      ),
    );
  }

  Widget _buildTitle(WidgetRef ref, ReportsPalette palette) {
    final subtitle = switch (ref.watch(reportsProvider).summaryState) {
      UiSuccess<ReportsSummary>(:final data) =>
        '${data.total} fermentaciones registradas',
      _ => 'Cargando...',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Reportes',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: palette.textPrimary,
            height: 1.1,
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
    );
  }

  Widget _buildSummary(WidgetRef ref, ReportsPalette palette) {
    return switch (ref.watch(reportsProvider).summaryState) {
      UiLoading<ReportsSummary>() => ReportsSummarySkeleton(palette: palette),
      UiSuccess<ReportsSummary>(:final data) => ReportSummaryCards(
        summary: data,
        palette: palette,
      ),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildList(
    BuildContext context,
    WidgetRef ref,
    ReportsPalette palette,
  ) {
    return switch (ref.watch(reportsProvider).reportsState) {
      UiLoading<List<ReportItem>>() => ReportsListSkeleton(palette: palette),
      UiError<List<ReportItem>>(:final message) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(
          child: ReportsErrorState(
            message: message,
            palette: palette,
            onRetry: ref.read(reportsProvider.notifier).refresh,
          ),
        ),
      ),
      UiSuccess<List<ReportItem>>(:final data) when data.isEmpty => SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(child: ReportsEmptyState(palette: palette)),
      ),
      UiSuccess<List<ReportItem>>(:final data) => ReportsList(
        reports: data,
        palette: palette,
        onViewReport: (report) {
          final sessionId = _extractSessionId(report.id);
          if (sessionId != null) {
            context.go('/report-detail', extra: sessionId);
          }
        },
        onDownloadPdf: (report) {
          final sessionId = _extractSessionId(report.id);
          if (sessionId != null) {
            ref.read(reportsProvider.notifier).downloadReportPdf(sessionId);
          }
        },
      ),
      _ => const SizedBox.shrink(),
    };
  }
}
