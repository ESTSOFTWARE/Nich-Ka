import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/report_item.dart';
import '../theme/reports_palette.dart';

class ReportCard extends StatelessWidget {
  final ReportItem report;
  final ReportsPalette palette;
  final VoidCallback? onViewReport;
  final VoidCallback? onDownloadPdf;

  const ReportCard({
    super.key,
    required this.report,
    required this.palette,
    this.onViewReport,
    this.onDownloadPdf,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 4),
          _buildSubtitle(),
          const SizedBox(height: 12),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          report.title,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: palette.textPrimary,
          ),
        ),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    if (report.isEnCurso) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFF75D079).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: const Color(0xFF75D079).withValues(alpha: 0.4),
          ),
        ),
        child: Text(
          'EN CURSO',
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF75D079),
            letterSpacing: 0.5,
          ),
        ),
      );
    }

    if (report.isInterrupted) {
      return Text(
        'Interrumpida',
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: ReportsPalette.interrupted,
        ),
      );
    }

    if (report.isNew) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
          color: ReportsPalette.accent.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: ReportsPalette.accent.withValues(alpha: 0.4),
          ),
        ),
        child: Text(
          'NUEVO',
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: ReportsPalette.accent,
            letterSpacing: 0.5,
          ),
        ),
      );
    }

    if (report.efficiency != null) {
      return Text(
        '${report.efficiency!.toStringAsFixed(1)}% eficiencia',
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: ReportsPalette.accent,
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildSubtitle() {
    return Row(
      children: [
        Text(
          report.id,
          style: GoogleFonts.poppins(fontSize: 12, color: palette.textMuted),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Container(
            width: 3,
            height: 3,
            decoration: BoxDecoration(
              color: palette.textMuted,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Text(
          report.date,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: palette.textSecondary,
          ),
        ),
        if (report.duration != '—') ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Container(
              width: 3,
              height: 3,
              decoration: BoxDecoration(
                color: palette.textMuted,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Text(
            report.duration,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: palette.textSecondary,
            ),
          ),
        ] else ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Container(
              width: 3,
              height: 3,
              decoration: BoxDecoration(
                color: palette.textMuted,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Text(
            '—',
            style: GoogleFonts.poppins(fontSize: 12, color: palette.textMuted),
          ),
        ],
        if (report.isNew && report.efficiency != null) ...[
          const Spacer(),
          Text(
            '${report.efficiency!.toStringAsFixed(1)}% eficiencia',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: ReportsPalette.accent,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            label: 'Ver reporte',
            filled: false,
            palette: palette,
            onTap: onViewReport,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionButton(
            label: 'PDF',
            filled: true,
            icon: Icons.download_outlined,
            palette: palette,
            onTap: onDownloadPdf,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final bool filled;
  final IconData? icon;
  final ReportsPalette palette;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.label,
    required this.filled,
    required this.palette,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: filled
              ? ReportsPalette.accent.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: filled
                ? ReportsPalette.accent.withValues(alpha: 0.5)
                : palette.border,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: filled ? ReportsPalette.accent : palette.textSecondary,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: filled ? ReportsPalette.accent : palette.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
