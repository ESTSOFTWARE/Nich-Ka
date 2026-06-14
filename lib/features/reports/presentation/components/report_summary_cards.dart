import 'package:flutter/material.dart';
import '../../domain/entities/reports_summary.dart';
import '../theme/reports_palette.dart';
import 'report_summary_card.dart';

class ReportSummaryCards extends StatelessWidget {
  final ReportsSummary summary;
  final ReportsPalette palette;

  const ReportSummaryCards({
    super.key,
    required this.summary,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ReportSummaryCard(
          label: 'Eficiencia\nProm.',
          value: '${summary.avgEfficiency.toStringAsFixed(1)}%',
          palette: palette,
        ),
        const SizedBox(width: 8),
        ReportSummaryCard(
          label: 'Total',
          value: '${summary.total}',
          palette: palette,
        ),
        const SizedBox(width: 8),
        ReportSummaryCard(
          label: 'Completas',
          value: '${summary.completed}',
          palette: palette,
        ),
      ],
    );
  }
}
