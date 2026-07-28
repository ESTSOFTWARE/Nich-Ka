part of 'profile_view.dart';

class _InlineDescRow extends StatelessWidget {
  final TextEditingController controller;
  final ProfilePalette palette;

  const _InlineDescRow({required this.controller, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Descripción',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            inputFormatters: AppInputFormatters.text,
            controller: controller,
            maxLines: 3,
            maxLength: 300,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: palette.textPrimary,
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Cuéntanos un poco sobre ti…',
              hintStyle: GoogleFonts.poppins(
                fontSize: 14,
                color: palette.textMuted,
              ),
              counterStyle: GoogleFonts.poppins(
                fontSize: 10,
                color: palette.textMuted,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
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
        ],
      ),
    );
  }
}
