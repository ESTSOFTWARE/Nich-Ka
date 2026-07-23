import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_palette.dart';
import 'app_tab.dart';

class TabIcon extends StatelessWidget {
  final AppTab tab;
  final bool isSelected;
  final AppPalette palette;
  final double size;

  const TabIcon({
    super.key,
    required this.tab,
    required this.isSelected,
    required this.palette,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? palette.navActive : palette.navInactive;
    return SvgPicture.asset(
      _iconPath(tab),
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  String _iconPath(AppTab tab) {
    switch (tab) {
      case AppTab.inicio:
        return 'assets/icons/home.svg';
      case AppTab.lotes:
        return 'assets/icons/lotes.svg';
      case AppTab.sensores:
        return 'assets/icons/sensores.svg';
      case AppTab.asistente:
        return 'assets/icons/asistente.svg';
    }
  }
}
