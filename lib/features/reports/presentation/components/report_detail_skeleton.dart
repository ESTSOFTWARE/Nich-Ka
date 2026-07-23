import 'package:flutter/material.dart';
import '../theme/reports_palette.dart';

class ReportDetailSkeleton extends StatelessWidget {
  final ReportsPalette palette;

  const ReportDetailSkeleton({super.key, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBlock(height: 72),
        const SizedBox(height: 12),
        _buildBlock(height: 220),
        const SizedBox(height: 12),
        _buildBlock(height: 200),
        const SizedBox(height: 12),
        _buildBlock(height: 240),
        const SizedBox(height: 12),
        _buildBlock(height: 44),
      ],
    );
  }

  Widget _buildBlock({required double height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.border),
      ),
    );
  }
}
