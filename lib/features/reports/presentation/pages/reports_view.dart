import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import '../../../../core/presentation/change_notifier_provider.dart';
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
import '../providers/reports_provider.dart';
import '../states/ui_state.dart';
import '../theme/reports_palette.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReportsProvider>(
      create: () => ReportsProvider(),
      builder: (context, provider) {
        final isDark = AppThemeScope.of(context).isDark;
        final palette = ReportsPalette.of(isDark);
        final homePalette = AppPalette.of(isDark);

        _handleDownloadSnackbar(context, provider);

        return Scaffold(
          key: provider.scaffoldKey,
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
                  automaticallyImplyLeading: false,
                  titleSpacing: 16,
                  title: Row(
                    children: [
                      _buildBackButton(context, palette),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTitle(provider, palette)),
                      _buildFilterButton(palette),
                    ],
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
                onRefresh: provider.refresh,
                child: SingleChildScrollView(
                  controller: provider.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    16,
                    MediaQuery.of(context).padding.top + kToolbarHeight + 16,
                    16,
                    24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReportsFilterBar(
                        selected: provider.selectedFilter,
                        palette: palette,
                        onSelected: provider.selectFilter,
                      ),
                      const SizedBox(height: 16),
                      _buildSummary(provider, palette),
                      const SizedBox(height: 16),
                      _buildList(context, provider, palette),
                    ],
                  ),
                ),
              ),
              if (provider.isDownloading) _buildDownloadOverlay(palette),
            ],
          ),
        );
      },
    );
  }

  void _handleDownloadSnackbar(BuildContext context, ReportsProvider provider) {
    if (provider.downloadError != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.downloadError!),
            backgroundColor: Colors.red,
          ),
        );
        provider.clearDownloadFlags();
      });
    } else if (provider.downloadCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('PDF descargado correctamente.'),
            backgroundColor: Colors.green,
          ),
        );
        provider.clearDownloadFlags();
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

  Widget _buildTitle(ReportsProvider provider, ReportsPalette palette) {
    final subtitle = switch (provider.summaryState) {
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
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: palette.textPrimary,
            letterSpacing: -0.5,
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

  Widget _buildSummary(ReportsProvider provider, ReportsPalette palette) {
    return switch (provider.summaryState) {
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
    ReportsProvider provider,
    ReportsPalette palette,
  ) {
    return switch (provider.reportsState) {
      UiLoading<List<ReportItem>>() => ReportsListSkeleton(palette: palette),
      UiError<List<ReportItem>>(:final message) => ReportsErrorState(
        message: message,
        palette: palette,
        onRetry: provider.refresh,
      ),
      UiSuccess<List<ReportItem>>(:final data) when data.isEmpty =>
        ReportsEmptyState(palette: palette),
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
          if (sessionId != null) provider.downloadReportPdf(sessionId);
        },
      ),
      _ => const SizedBox.shrink(),
    };
  }
}
