import 'package:flutter/material.dart';
import '../../domain/entities/report_item.dart';
import '../theme/reports_palette.dart';
import 'report_card.dart';

class ReportsList extends StatelessWidget {
  final List<ReportItem> reports;
  final ReportsPalette palette;

  const ReportsList({super.key, required this.reports, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: reports.map((report) {
        final isLast = report == reports.last;
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
          child: ReportCard(report: report, palette: palette),
        );
      }).toList(),
    );
  }
}
