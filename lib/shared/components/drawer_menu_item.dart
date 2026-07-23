import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/presentation/responsive.dart';
import '../theme/app_palette.dart';
import 'app_drawer_item.dart';

class DrawerMenuItem extends StatelessWidget {
  final AppDrawerItem item;
  final bool isSelected;
  final AppPalette palette;
  final VoidCallback onTap;

  const DrawerMenuItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.palette,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isSelected ? AppPalette.accent : palette.textSecondary;
    final tablet = isTablet(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        padding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: tablet ? 16 : 13,
        ),
        decoration: BoxDecoration(
          color: isSelected ? palette.rowSurface : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            _icon(iconColor, tablet ? 28.0 : 20.0),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                _label(),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? palette.textPrimary
                      : palette.textSecondary,
                ),
              ),
            ),
            if (isSelected)
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: AppPalette.accent,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _icon(Color color, double size) {
    final svgPath = _svgPath();
    if (svgPath != null) {
      return SvgPicture.asset(
        svgPath,
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    }
    return Icon(_iconData(), size: size, color: color);
  }

  String? _svgPath() {
    switch (item) {
      case AppDrawerItem.inicio:
        return 'assets/icons/home.svg';
      case AppDrawerItem.sensores:
        return 'assets/icons/sensores.svg';
      case AppDrawerItem.asistente:
        return 'assets/icons/asistente.svg';
      default:
        return null;
    }
  }

  IconData _iconData() {
    switch (item) {
      case AppDrawerItem.fermentaciones:
        return Icons.format_list_bulleted;
      case AppDrawerItem.mensajes:
        return Icons.chat_bubble_outline;
      case AppDrawerItem.calculadora:
        return Icons.calculate_outlined;
      case AppDrawerItem.simulador:
        return Icons.science_outlined;
      case AppDrawerItem.clases:
        return Icons.school_outlined;
      case AppDrawerItem.reportes:
        return Icons.description_outlined;
      default:
        return Icons.circle_outlined;
    }
  }

  String _label() {
    switch (item) {
      case AppDrawerItem.inicio:
        return 'Inicio';
      case AppDrawerItem.fermentaciones:
        return 'Mis fermentaciones';
      case AppDrawerItem.sensores:
        return 'Sensores';
      case AppDrawerItem.asistente:
        return 'Asistente IA';
      case AppDrawerItem.mensajes:
        return 'Mensajes';
      case AppDrawerItem.calculadora:
        return 'Calculadora';
      case AppDrawerItem.simulador:
        return 'Simulador';
      case AppDrawerItem.clases:
        return 'Clases';
      case AppDrawerItem.reportes:
        return 'Reportes';
    }
  }
}
