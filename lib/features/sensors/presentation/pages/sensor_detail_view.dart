import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import '../../../../core/presentation/change_notifier_provider.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../../home/presentation/components/home_glow.dart';
import '../../domain/entities/sensor_reading.dart';
import '../components/sensor_ai_insight.dart';
import '../components/sensor_detail_chart.dart';
import '../components/sensor_range_bar.dart';
import '../components/sensor_stats_row.dart';
import '../providers/sensor_detail_provider.dart';
import '../../../../core/presentation/responsive_center.dart';
import '../../../../core/presentation/responsive.dart';

class SensorDetailView extends StatelessWidget {
  final SensorReading reading;

  const SensorDetailView({super.key, required this.reading});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SensorDetailProvider>(
      create: () => SensorDetailProvider(reading),
      builder: (context, provider) {
        final isDark = AppThemeScope.of(context).isDark;
        final palette = AppPalette.of(isDark);
        final color = provider.reading.color;
        final range = provider.range;

        return Scaffold(
          backgroundColor: palette.background,
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
              (kToolbarHeight + 20) *
                  (isTablet(context) ? kTabletHeaderScale : 1.0),
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
                    toolbarHeight:
                        (kToolbarHeight + 20) *
                        (isTablet(context) ? kTabletHeaderScale : 1.0),
                    leading: Center(
                      child: GestureDetector(
                        onTap: () => context.canPop()
                            ? context.pop()
                            : context.go('/sensors'),
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          provider.reading.label,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: palette.textPrimary,
                          ),
                        ),
                        Text(
                          '${range.contextLabel} · F-024',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: palette.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      Container(
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppPalette.accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppPalette.accent.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppPalette.accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'EN VIVO',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppPalette.accent,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
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
                  controller: provider.scrollController,
                  padding: EdgeInsets.fromLTRB(
                    16,
                    MediaQuery.of(context).padding.top +
                        (kToolbarHeight + 28) *
                            (isTablet(context) ? kTabletHeaderScale : 1.0),
                    16,
                    MediaQuery.of(context).padding.bottom + 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: palette.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: palette.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: color.withValues(
                                      alpha: isDark ? 0.25 : 0.18,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    provider.reading.icon,
                                    color: color,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'LECTURA ACTUAL',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: palette.textMuted,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  provider.reading.displayValue,
                                  style: GoogleFonts.poppins(
                                    fontSize: 56,
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                    height: 1,
                                  ),
                                ),
                                if (provider.reading.unit.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 6,
                                      left: 4,
                                    ),
                                    child: Text(
                                      provider.reading.unit,
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        color: palette.textSecondary,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    (provider.isInRange
                                            ? AppPalette.accent
                                            : Colors.red[400]!)
                                        .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                provider.isInRange
                                    ? '● EN RANGO ÓPTIMO'
                                    : '● FUERA DE RANGO',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: provider.isInRange
                                      ? AppPalette.accent
                                      : Colors.red[400]!,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SensorRangeBar(
                              range: range,
                              currentValue: provider.reading.rawValue,
                              unit: provider.reading.unit,
                              color: color,
                              palette: palette,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SensorDetailChart(
                        points: provider.chartPoints,
                        color: color,
                        selectedWindow: provider.window,
                        onWindowChanged: provider.setWindow,
                        palette: palette,
                      ),
                      const SizedBox(height: 16),
                      SensorStatsRow(
                        minValue: provider.minValue,
                        avgValue: provider.avgValue,
                        maxValue: provider.maxValue,
                        unit: provider.reading.unit,
                        decimals: provider.reading.decimals,
                        palette: palette,
                      ),
                      const SizedBox(height: 16),
                      SensorAiInsight(
                        text: provider.aiInsight,
                        inRange: provider.isInRange,
                        palette: palette,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
