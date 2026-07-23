part of 'home_view.dart';

class _PredictButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _PredictButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppPalette.accent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppPalette.accent.withValues(alpha: 0.35)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppPalette.accent,
                ),
              )
            else
              const Icon(
                Icons.auto_awesome,
                size: 16,
                color: AppPalette.accent,
              ),
            const SizedBox(width: 8),
            Text(
              isLoading
                  ? 'Solicitando predicción…'
                  : 'Solicitar predicción de eficiencia',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppPalette.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
