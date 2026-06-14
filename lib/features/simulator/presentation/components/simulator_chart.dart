import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../domain/entities/simulator_point.dart';

class SimulatorChart extends StatelessWidget {
  final List<SimulatorPoint> points;
  final AppPalette palette;

  const SimulatorChart({
    super.key,
    required this.points,
    required this.palette,
  });

  static const _colorBiomasa = AppPalette.accent;
  static const _colorSustrato = Color(0xFFFFB347);
  static const _colorProducto = Color(0xFFFF6B35);

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const SizedBox(height: 160);
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineTouchData: const LineTouchData(enabled: false),
              lineBarsData: [
                _bar(
                  points.map((p) => FlSpot(p.t, p.x)).toList(),
                  _colorBiomasa,
                ),
                _bar(
                  points.map((p) => FlSpot(p.t, p.s)).toList(),
                  _colorSustrato,
                ),
                _bar(
                  points.map((p) => FlSpot(p.t, p.p)).toList(),
                  _colorProducto,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _legendItem(_colorBiomasa, 'Biomasa (X)', palette),
            const SizedBox(width: 16),
            _legendItem(_colorSustrato, 'Sustrato (S)', palette),
            const SizedBox(width: 16),
            _legendItem(_colorProducto, 'Producto (P)', palette),
          ],
        ),
      ],
    );
  }

  LineChartBarData _bar(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      color: color,
      barWidth: 2,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

  Widget _legendItem(Color color, String label, AppPalette palette) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: palette.textSecondary,
          ),
        ),
      ],
    );
  }
}
