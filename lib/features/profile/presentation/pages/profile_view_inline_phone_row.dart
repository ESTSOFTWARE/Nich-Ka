part of 'profile_view.dart';

class _InlinePhoneRow extends StatelessWidget {
  final TextEditingController controller;
  final String dialCode;
  final ProfilePalette palette;
  final VoidCallback onDialCodeTap;

  const _InlinePhoneRow({
    required this.controller,
    required this.dialCode,
    required this.palette,
    required this.onDialCodeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              'Teléfono',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: palette.textSecondary,
              ),
            ),
          ),
          GestureDetector(
            onTap: onDialCodeTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  dialCode,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ProfilePalette.accent,
                  ),
                ),
                const Icon(Icons.arrow_drop_down, size: 16),
                const SizedBox(width: 6),
              ],
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              textAlign: TextAlign.end,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
              decoration: InputDecoration(
                isDense: true,
                hintText: '10 dígitos',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 14,
                  color: palette.textMuted,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: ProfilePalette.accent,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
