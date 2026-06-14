import 'package:flutter/material.dart';
import '../../../../shared/theme/app_palette.dart';
import 'sensor_stat_tile.dart';

class SensorStatsRow extends StatelessWidget {
  final double minValue;
  final double avgValue;
  final double maxValue;
  final String unit;
  final int decimals;
  final AppPalette palette;

  const SensorStatsRow({
    super.key,
    required this.minValue,
    required this.avgValue,
    required this.maxValue,
    required this.unit,
    required this.decimals,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SensorStatTile(
          label: 'MÍNIMO',
          value: minValue.toStringAsFixed(decimals),
          unit: unit,
          palette: palette,
        ),
        const SizedBox(width: 10),
        SensorStatTile(
          label: 'PROMEDIO',
          value: avgValue.toStringAsFixed(decimals),
          unit: unit,
          palette: palette,
        ),
        const SizedBox(width: 10),
        SensorStatTile(
          label: 'MÁXIMO',
          value: maxValue.toStringAsFixed(decimals),
          unit: unit,
          palette: palette,
        ),
      ],
    );
  }
}
