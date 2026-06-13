import 'package:flutter/material.dart';
import '../../domain/entities/dashboard_stat.dart';
import '../theme/home_palette.dart';
import 'summary_stat_card.dart';

class StatsOverviewGrid extends StatelessWidget {
  final List<DashboardStat> stats;
  final HomePalette palette;

  const StatsOverviewGrid({
    super.key,
    required this.stats,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: SummaryStatCard(stat: stats[0], palette: palette)),
              const SizedBox(width: 10),
              Expanded(child: SummaryStatCard(stat: stats[1], palette: palette)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: SummaryStatCard(stat: stats[2], palette: palette)),
              const SizedBox(width: 10),
              Expanded(child: SummaryStatCard(stat: stats[3], palette: palette)),
            ],
          ),
        ),
      ],
    );
  }
}
