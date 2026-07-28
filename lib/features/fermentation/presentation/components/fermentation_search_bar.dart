import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../../../core/validation/input_formatters.dart';

class FermentationSearchBar extends StatelessWidget {
  final AppPalette palette;
  final TextEditingController controller;

  const FermentationSearchBar({
    super.key,
    required this.palette,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      inputFormatters: AppInputFormatters.text,
      controller: controller,
      style: GoogleFonts.poppins(fontSize: 13, color: palette.textPrimary),
      decoration: InputDecoration(
        hintText: 'Buscar fermentación, variedad...',
        hintStyle: GoogleFonts.poppins(fontSize: 13, color: palette.textMuted),
        prefixIcon: Icon(Icons.search, size: 18, color: palette.textMuted),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (_, value, _) => value.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  icon: Icon(Icons.close, size: 16, color: palette.textMuted),
                  onPressed: controller.clear,
                ),
        ),
        filled: true,
        fillColor: palette.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 11),
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
          borderSide: BorderSide(color: AppPalette.accent, width: 1.5),
        ),
      ),
    );
  }
}
