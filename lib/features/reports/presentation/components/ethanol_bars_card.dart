import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/reports_palette.dart';

/// Gráfica de barras: etanol teórico vs detectado.
class EthanolBarsCard extends StatelessWidget {
  final double detected;
  final double theoretical;
  final ReportsPalette palette;

  const EthanolBarsCard({
    super.key,
    required this.detected,
    required this.theoretical,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final maxY = [detected, theoretical, 1.0].reduce((a, b) => a > b ? a : b) * 1.3;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Etanol: teórico vs detectado (%v/v)',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                alignment: BarChartAlignment.spaceAround,
                barGroups: [
                  _bar(0, theoretical, const Color(0xFFA1A1AA)),
                  _bar(1, detected, const Color(0xFF22C55E)),
                ],
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        const labels = ['Teórico', 'Detectado'];
                        final i = value.toInt();
                        final txt = i >= 0 && i < labels.length ? labels[i] : '';
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            txt,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: palette.textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _bar(int x, double y, Color color) => BarChartGroupData(
        x: x,
        barRods: [
          BarChartRodData(
            toY: y,
            color: color,
            width: 38,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ],
      );
}
