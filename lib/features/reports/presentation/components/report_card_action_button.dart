part of 'report_card.dart';

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
