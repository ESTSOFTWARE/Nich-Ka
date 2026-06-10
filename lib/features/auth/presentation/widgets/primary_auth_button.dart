import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryAuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryAuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Ocupa todo el ancho disponible
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          disabledBackgroundColor: Colors.white.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Iniciando sesión...',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        )
            : Text(
          text,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}