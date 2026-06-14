import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(top: BorderSide(color: palette.border)),
      ),
      padding: const EdgeInsets.only(bottom: 8),
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
                  const SizedBox(height: 10),
                  TabIcon(tab: tab, isSelected: isSelected, palette: palette),
                  const SizedBox(height: 4),
                  Text(
                    _label(tab),
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? palette.navActive
                          : palette.navInactive,
                    ),
                  ),
                  const SizedBox(height: 4),
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
