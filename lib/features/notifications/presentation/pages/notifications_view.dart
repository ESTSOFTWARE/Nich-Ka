import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import '../../../../core/presentation/change_notifier_provider.dart';
import '../../../home/presentation/theme/home_palette.dart';
import '../components/notification_list_item.dart';
import '../providers/notifications_provider.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotificationsProvider>(
      create: () => NotificationsProvider(),
      builder: (context, provider) {
        final isDark = AppThemeScope.of(context).isDark;
        final palette = HomePalette.of(isDark);
        return Scaffold(
          backgroundColor: palette.background,
          appBar: AppBar(
            backgroundColor: palette.background,
            elevation: 0,
            scrolledUnderElevation: 0,
            systemOverlayStyle: isDark
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
            automaticallyImplyLeading: false,
            centerTitle: false,
            leadingWidth: 56,
            leading: Center(
              child: GestureDetector(
                onTap: () =>
                    context.canPop() ? context.pop() : context.go('/home'),
                child: Container(
                  width: 36,
                  height: 36,
                  margin: const EdgeInsets.only(left: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: palette.border),
                  ),
                  child: Icon(
                    Icons.chevron_left,
                    color: palette.textPrimary,
                    size: 22,
                  ),
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notificaciones',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: palette.textPrimary,
                  ),
                ),
                if (provider.unreadCount > 0)
                  Text(
                    '${provider.unreadCount} sin leer',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: palette.textSecondary,
                    ),
                  ),
              ],
            ),
            actions: [
              if (provider.unreadCount > 0)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: provider.markAllRead,
                    child: Text(
                      'Marcar todo',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: HomePalette.accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          body: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: provider.items.length,
            itemBuilder: (context, index) => NotificationListItem(
              item: provider.items[index],
              palette: palette,
            ),
          ),
        );
      },
    );
  }
}
