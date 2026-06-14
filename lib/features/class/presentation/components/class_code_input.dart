import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';

class ClassCodeInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String code;
  final AppPalette palette;

  const ClassCodeInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.code,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(8, (i) {
              final char = i < code.length ? code[i] : null;
              final filled = char != null;
              return Container(
                width: 36,
                height: 44,
                decoration: BoxDecoration(
                  color: filled ? AppPalette.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: filled ? AppPalette.accent : palette.border,
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: filled
                    ? Text(
                        char,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )
                    : const SizedBox.shrink(),
              );
            }),
          ),
          TextField(
            controller: controller,
            focusNode: focusNode,
            maxLength: 8,
            textCapitalization: TextCapitalization.characters,
            style: const TextStyle(color: Colors.transparent),
            cursorColor: Colors.transparent,
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
