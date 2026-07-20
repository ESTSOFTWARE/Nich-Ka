import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../domain/entities/notification_item.dart';
import '../../domain/entities/notification_type.dart';

class NotificationListItem extends StatelessWidget {
  final NotificationItem item;
  final AppPalette palette;

  const NotificationListItem({
    super.key,
    required this.item,
    required this.palette,
  });

  (IconData, Color) get _typeStyle => switch (item.type) {
    NotificationType.recommendation => (Icons.auto_awesome, AppPalette.accent),
    NotificationType.alert => (
      Icons.warning_amber_rounded,
      AppPalette.metricOrange,
    ),
    NotificationType.completed => (
      Icons.check_rounded,
      const Color(0xFF7B5E3A),
    ),
    NotificationType.analysis => (
      Icons.analytics_outlined,
      const Color(0xFF60A5FA),
    ),
    NotificationType.sensor => (
      Icons.warning_amber_rounded,
      AppPalette.metricRed,
    ),
    NotificationType.fermentation => (
      Icons.science_outlined,
      const Color(0xFF14B8A6),
    ),
    NotificationType.group => (
      Icons.group_outlined,
      const Color(0xFF34D399),
    ),
    NotificationType.announcement => (
      Icons.campaign_outlined,
      const Color(0xFFFBBF24),
    ),
    NotificationType.user => (
      Icons.person_outline,
      const Color(0xFFA78BFA),
    ),
    NotificationType.prediction => (
      Icons.insights,
      AppPalette.metricPurple,
    ),
    NotificationType.general => (
      Icons.notifications_none,
      const Color(0xFF8A8A8E),
    ),
  };

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _typeStyle;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            item.title,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: palette.textPrimary,
                            ),
                          ),
                          if (!item.isRead) ...[
                            const SizedBox(width: 6),
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: AppPalette.accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Text(
                      item.time,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: palette.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  item.description,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: palette.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
