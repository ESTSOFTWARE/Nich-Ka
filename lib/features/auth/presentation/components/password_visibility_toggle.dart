import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';

/// Responsabilidad única: botón con ícono de ojo para mostrar/ocultar la
/// contraseña. No gestiona estado; recibe el valor actual y notifica el cambio.
class PasswordVisibilityToggle extends StatelessWidget {
  final bool isObscured;
  final VoidCallback onPressed;

  const PasswordVisibilityToggle({
    super.key,
    required this.isObscured,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: SvgPicture.asset(
        isObscured
            ? 'assets/icons/eye-slash.svg'
            : 'assets/icons/eye.svg',
        colorFilter: const ColorFilter.mode(
          AppColors.textMuted,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
