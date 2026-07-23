part of 'profile_view.dart';

class _Chip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final Color borderColor;
  final VoidCallback? onTap;

  const _Chip({
    required this.label,
    this.icon,
    required this.color,
    required this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: disabled
                ? borderColor.withValues(alpha: 0.3)
                : borderColor.withValues(alpha: 0.6),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 13,
                color: disabled ? color.withValues(alpha: 0.3) : color,
              ),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: disabled ? color.withValues(alpha: 0.3) : color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
