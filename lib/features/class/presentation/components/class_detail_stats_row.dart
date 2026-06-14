import 'package:flutter/material.dart';
import '../theme/class_palette.dart';
import 'class_stat_tile.dart';

class ClassDetailStatsRow extends StatelessWidget {
  final int studentCount;
  final DateTime createdAt;
  final ClassPalette palette;

  const ClassDetailStatsRow({
    super.key,
    required this.studentCount,
    required this.createdAt,
    required this.palette,
  });

  String _formatDate(DateTime date) {
    const months = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClassStatTile(
          icon: Icons.person_outline,
          label: 'ALUMNOS',
          value: '$studentCount',
          palette: palette,
        ),
        const SizedBox(width: 10),
        ClassStatTile(
          icon: Icons.calendar_today_outlined,
          label: 'CREADA',
          value: _formatDate(createdAt),
          palette: palette,
        ),
      ],
    );
  }
}
