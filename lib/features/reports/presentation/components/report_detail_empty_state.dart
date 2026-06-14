import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/reports_palette.dart';

class ReportDetailEmptyState extends StatelessWidget {
  final ReportsPalette palette;

  const ReportDetailEmptyState({super.key, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: ReportsPalette.accent.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: ReportsPalette.accent.withValues(alpha: 0.25),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.description_outlined,
                size: 28,
                color: ReportsPalette.accent,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Reporte no encontrado',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'El reporte que buscas no está disponible.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: palette.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
