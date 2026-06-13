import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/home/presentation/theme/home_palette.dart';
import 'app_drawer_item.dart';

class DrawerMenuItem extends StatelessWidget {
  final AppDrawerItem item;
  final bool isSelected;
  final HomePalette palette;
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
    final iconColor =
        isSelected ? HomePalette.accent : palette.textSecondary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: isSelected ? palette.rowSurface : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            _icon(iconColor),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                _label(),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
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
                  color: HomePalette.accent,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _icon(Color color) {
    final svgPath = _svgPath();
    if (svgPath != null) {
      return SvgPicture.asset(
        svgPath,
        width: 20,
        height: 20,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    }
    return Icon(_iconData(), size: 20, color: color);
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
      case AppDrawerItem.reportes:
        return Icons.description_outlined;
      case AppDrawerItem.historico:
        return Icons.history;
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
      case AppDrawerItem.reportes:
        return 'Reportes';
      case AppDrawerItem.historico:
        return 'Histórico';
    }
  }
}
