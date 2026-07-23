import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/presentation/responsive.dart';
import '../theme/app_palette.dart';
import 'app_tab.dart';
import 'tab_icon.dart';

class BottomNavBar extends StatelessWidget {
  final AppTab selected;
  final AppPalette palette;
  final ValueChanged<AppTab> onTabSelected;

  const BottomNavBar({
    super.key,
    required this.selected,
    required this.palette,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scale = isTablet(context) ? 1.5 : 1.0;
    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(top: BorderSide(color: palette.border)),
      ),
      padding: EdgeInsets.only(bottom: 8 * scale),
      child: Row(
        children: AppTab.values.map((tab) {
          final isSelected = tab == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(tab),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10 * scale),
                  TabIcon(
                    tab: tab,
                    isSelected: isSelected,
                    palette: palette,
                    size: 22 * scale,
                  ),
                  SizedBox(height: 4 * scale),
                  Text(
                    _label(tab),
                    style: GoogleFonts.poppins(
                      fontSize: 11 * scale,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? palette.navActive
                          : palette.navInactive,
                    ),
                  ),
                  SizedBox(height: 4 * scale),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _label(AppTab tab) {
    switch (tab) {
      case AppTab.inicio:
        return 'Inicio';
      case AppTab.lotes:
        return 'Lotes';
      case AppTab.sensores:
        return 'Sensores';
      case AppTab.asistente:
        return 'Asistente';
    }
  }
}
