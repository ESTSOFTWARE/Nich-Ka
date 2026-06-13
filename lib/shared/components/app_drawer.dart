import 'package:flutter/material.dart';
import '../../features/home/presentation/theme/home_palette.dart';
import 'app_drawer_header.dart';
import 'app_drawer_item.dart';
import 'drawer_bottom_action.dart';
import 'drawer_menu_item.dart';

class AppDrawer extends StatelessWidget {
  final HomePalette palette;
  final AppDrawerItem selected;
  final ValueChanged<AppDrawerItem> onSelected;
  final VoidCallback? onSettings;
  final VoidCallback? onLogout;

  const AppDrawer({
    super.key,
    required this.palette,
    required this.selected,
    required this.onSelected,
    this.onSettings,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: palette.surface,
      width: MediaQuery.of(context).size.width * 0.82,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppDrawerHeader(palette: palette),
            ...AppDrawerItem.values.map(
              (item) => DrawerMenuItem(
                item: item,
                isSelected: item == selected,
                palette: palette,
                onTap: () {
                  Navigator.of(context).pop();
                  onSelected(item);
                },
              ),
            ),
            const Spacer(),
            Divider(color: palette.border, height: 1),
            const SizedBox(height: 4),
            DrawerBottomAction(
              icon: Icons.settings_outlined,
              label: 'Configuración',
              palette: palette,
              onTap: () {
                Navigator.of(context).pop();
                onSettings?.call();
              },
            ),
            DrawerBottomAction(
              icon: Icons.logout,
              label: 'Cerrar sesión',
              palette: palette,
              onTap: () {
                Navigator.of(context).pop();
                onLogout?.call();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
