import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

/// Botón de acción principal del formulario. Dos variantes:
/// - [filled] = true  -> relleno blanco con texto oscuro (acción destacada).
/// - [filled] = false -> oscuro con borde y texto blanco.
///
/// Admite un ícono SVG opcional a la izquierda y un spinner mientras [isLoading].
class PrimaryAuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool filled;
  final String? iconPath;

  const PrimaryAuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.filled = true,
    this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    // El color del contenido depende de la variante.
    final Color foreground =
        filled ? AppColors.background : AppColors.textPrimary;

    return SizedBox(
      width: double.infinity, // Ocupa todo el ancho disponible
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: filled ? AppColors.textPrimary : AppColors.surface,
          side: BorderSide(
            color: filled ? Colors.transparent : AppColors.border,
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(foreground),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Enviando...',
                    style: GoogleFonts.poppins(
                      color: foreground,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (iconPath != null) ...[
                    SvgPicture.asset(
                      iconPath!,
                      width: 18,
                      height: 18,
                      colorFilter: ColorFilter.mode(
                        foreground,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: GoogleFonts.poppins(
                      color: foreground,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
