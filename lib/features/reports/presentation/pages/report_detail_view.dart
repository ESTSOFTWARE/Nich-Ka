import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import '../../../../core/presentation/change_notifier_provider.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../../home/presentation/components/home_glow.dart';
import '../../domain/entities/report_detail.dart';
import '../components/efficiency_card.dart';
import '../components/ethanol_bars_card.dart';
import '../components/nlp_analysis_card.dart';
import '../components/report_detail_skeleton.dart';
import '../components/report_metadata.dart';
import '../components/sensors_metrics_card.dart';
import '../providers/report_detail_provider.dart';
import '../states/ui_state.dart';
import '../theme/reports_palette.dart';
import '../../../../core/presentation/responsive_center.dart';
import '../../../../core/presentation/responsive.dart';

class ReportDetailView extends StatelessWidget {
  final int? sessionId;

  const ReportDetailView({super.key, this.sessionId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReportDetailProvider>(
      create: () => ReportDetailProvider(sessionId: sessionId),
      builder: (context, provider) {
        final isDark = AppThemeScope.of(context).isDark;
        final palette = ReportsPalette.of(isDark);
        final homePalette = AppPalette.of(isDark);

        _handleDownloadSnackbar(context, provider);

        final successData = switch (provider.state) {
          UiSuccess<ReportDetail>(:final data) => data,
          _ => null,
        };

        final barScale = isTablet(context) ? kTabletHeaderScale : 1.0;
        final toolbarHeight =
            (successData != null ? 64.0 : kToolbarHeight) * barScale;

        return Scaffold(
          backgroundColor: palette.background,
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(toolbarHeight),
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
                    toolbarHeight: toolbarHeight,
                    leadingWidth: 56,
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: GestureDetector(
                        onTap: () => context.canPop()
                            ? context.pop()
                            : context.go('/reports'),
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
                    title: successData != null
                        ? _buildHeaderTitle(successData, palette)
                        : Text(
                            'Detalle de Reporte',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: palette.textPrimary,
                            ),
                          ),
                    actions: [
                      if (successData != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: GestureDetector(
                            onTap: provider.isDownloading
                                ? null
                                : () => provider.downloadReportPdf(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: ReportsPalette.accent.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: ReportsPalette.accent.withValues(
                                    alpha: 0.4,
                                  ),
                                ),
                              ),
                              child: provider.isDownloading
                                  ? SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: ReportsPalette.accent,
                                      ),
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.file_download_outlined,
                                          size: 16,
                                          color: ReportsPalette.accent,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'PDF',
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: ReportsPalette.accent,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        )
                      else
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
              HomeGlow(palette: homePalette),
              switch (provider.state) {
                UiLoading<ReportDetail>() => ResponsiveCenter(
                  child: SingleChildScrollView(
                    controller: provider.scrollController,
                    padding: EdgeInsets.fromLTRB(
                      16,
                      MediaQuery.of(context).padding.top +
                          (kToolbarHeight + 8) * barScale,
                      16,
                      32,
                    ),
                    child: ReportDetailSkeleton(palette: palette),
                  ),
                ),
                UiError<ReportDetail>(:final message) => _buildError(
                  context,
                  message,
                  provider.retry,
                  palette,
                  homePalette,
                ),
                UiSuccess<ReportDetail>(:final data) => _buildContent(
                  context,
                  provider,
                  data,
                  palette,
                  homePalette,
                ),
                _ => const SizedBox.shrink(),
              },
            ],
          ),
        );
      },
    );
  }

  void _handleDownloadSnackbar(
    BuildContext context,
    ReportDetailProvider provider,
  ) {
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

  Widget _buildHeaderTitle(ReportDetail detail, ReportsPalette palette) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reporte #${detail.reportNumber}',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: palette.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${detail.fermentationCode} · ${detail.batchName} · ${detail.date}',
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: palette.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    ReportDetailProvider provider,
    ReportDetail detail,
    ReportsPalette palette,
    AppPalette homePalette,
  ) {
    return ResponsiveCenter(
      child: SingleChildScrollView(
        controller: provider.scrollController,
        padding: EdgeInsets.fromLTRB(
          16,
          MediaQuery.of(context).padding.top +
              (kToolbarHeight + 24) *
                  (isTablet(context) ? kTabletHeaderScale : 1.0),
          16,
          32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EfficiencyCard(
              efficiency: detail.efficiency,
              ethanolDetected: detail.ethanolDetected,
              ethanolTheoretical: detail.ethanolTheoretical,
              duration: detail.duration,
              palette: palette,
            ),
            const SizedBox(height: 12),
            EthanolBarsCard(
              detected: detail.ethanolDetected,
              theoretical: detail.ethanolTheoretical,
              palette: palette,
            ),
            const SizedBox(height: 12),
            NlpAnalysisCard(analysis: detail.nlpAnalysis, palette: palette),
            const SizedBox(height: 12),
            SensorsMetricsCard(metrics: detail.sensorMetrics, palette: palette),
            const SizedBox(height: 12),
            ReportMetadata(
              generatedAt: detail.generatedAt,
              downloads: detail.downloads,
              views: detail.views,
              palette: palette,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(
    BuildContext context,
    String message,
    VoidCallback onRetry,
    ReportsPalette palette,
    AppPalette homePalette,
  ) {
    return ResponsiveCenter(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16,
          MediaQuery.of(context).padding.top +
              (kToolbarHeight + 8) *
                  (isTablet(context) ? kTabletHeaderScale : 1.0),
          16,
          32,
        ),
        child: Column(
          children: [
            const SizedBox(height: 48),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: ReportsPalette.error.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: ReportsPalette.error.withValues(alpha: 0.25),
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.error_outline,
                  size: 28,
                  color: ReportsPalette.error,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Ocurrió un error',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: palette.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: palette.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: palette.border),
                ),
                child: Text(
                  'Reintentar',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: palette.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
