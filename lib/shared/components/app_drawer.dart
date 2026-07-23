import 'package:flutter/material.dart';
import '../../core/presentation/responsive.dart';
import '../../core/session/current_user_avatar.dart';
import '../theme/app_palette.dart';
import 'app_drawer_header.dart';
import 'app_drawer_item.dart';
import 'drawer_bottom_action.dart';
import 'drawer_menu_item.dart';

class AppDrawer extends StatelessWidget {
  final AppPalette palette;
  final AppDrawerItem selected;
  final ValueChanged<AppDrawerItem> onSelected;
  final VoidCallback? onSettings;
  final VoidCallback? onLogout;
  final String? userName;
  final String? userRole;
  final String? profileImage;

  const AppDrawer({
    super.key,
    required this.palette,
    required this.selected,
    required this.onSelected,
    this.onSettings,
    this.onLogout,
    this.userName,
    this.userRole,
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    final tablet = isTablet(context);
    // En tablet un 82% del ancho es enorme; se acota a un panel razonable.
    final width = tablet
        ? MediaQuery.of(context).size.width.clamp(0, 900) * 0.42
        : MediaQuery.of(context).size.width * 0.82;

    return Drawer(
      backgroundColor: palette.surface,
      width: width.toDouble(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      // Escala el texto de todo el drawer en tablet (los íconos se escalan
      // en cada componente con su propio isTablet).
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(tablet ? kTabletTextScale : 1),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder<String?>(
                valueListenable: CurrentUserAvatar.instance,
                builder: (context, liveAvatar, child) => AppDrawerHeader(
                  palette: palette,
                  userName: userName ?? 'Usuario',
                  userRole: userRole ?? 'ESTUDIANTE',
                  profileImage: liveAvatar ?? profileImage,
                ),
              ),
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
      ),
    );
  }
}
