import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../../../core/validation/input_formatters.dart';

class MessagesSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final AppPalette palette;

  const MessagesSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      inputFormatters: AppInputFormatters.text,
      controller: controller,
      onChanged: onChanged,
      style: GoogleFonts.poppins(fontSize: 14, color: palette.textPrimary),
      decoration: InputDecoration(
        hintText: 'Buscar conversación...',
        hintStyle: GoogleFonts.poppins(fontSize: 14, color: palette.textMuted),
        prefixIcon: Icon(Icons.search, color: palette.textMuted, size: 20),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.close, color: palette.textMuted, size: 18),
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
              )
            : null,
        filled: true,
        fillColor: palette.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppPalette.accent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 11,
        ),
        isDense: true,
      ),
    );
  }
}
