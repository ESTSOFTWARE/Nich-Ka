import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import 'auth_field_label.dart';
import 'password_visibility_toggle.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool isPassword;
  final bool isObscured;
  final VoidCallback? onToggleObscure;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.isObscured = false,
    this.onToggleObscure,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          AuthFieldLabel(text: label),
          const SizedBox(height: 6),
        ],
        TextFormField(
          controller: controller,
          obscureText: isPassword && isObscured,
          keyboardType: keyboardType,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(color: AppColors.textMuted),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.accent.withValues(alpha: 0.6),
                width: 1,
              ),
            ),
            suffixIcon: isPassword
                ? PasswordVisibilityToggle(
                    isObscured: isObscured,
                    onPressed: onToggleObscure ?? () {},
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
