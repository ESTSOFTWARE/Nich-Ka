import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import '../../../../core/presentation/change_notifier_provider.dart';
import '../../../../shared/components/app_drawer.dart';
import '../../../../shared/components/app_drawer_item.dart';
import '../../../../shared/components/app_tab.dart';
import '../../../../shared/components/bottom_nav_bar.dart';
import '../../../../shared/components/main_app_bar.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../../../shared/utils/bottom_nav_navigation.dart';
import '../../../../shared/utils/drawer_navigation.dart';
import '../../../../features/profile/presentation/providers/drawer_provider.dart';
import '../components/home_empty_card.dart';
import '../components/home_feature_item.dart';
import '../components/home_glow.dart';
import '../providers/home_student_provider.dart';
import '../../../../core/presentation/responsive_center.dart';
import '../../../../core/presentation/responsive.dart';

class HomeStudentView extends StatelessWidget {
  const HomeStudentView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeStudentProvider>(
      create: () => HomeStudentProvider(),
      builder: (context, provider) {
        final isDark = AppThemeScope.of(context).isDark;
        final palette = AppPalette.of(isDark);
        return ChangeNotifierProvider<DrawerProvider>(
          create: () => DrawerProvider(),
          builder: (context, drawerProvider) {
            return Scaffold(
              key: provider.scaffoldKey,
              backgroundColor: palette.background,
              extendBodyBehindAppBar: true,
              drawer: AppDrawer(
                palette: palette,
                selected: AppDrawerItem.inicio,
                onSelected: (item) => onDrawerNav(context, item),
                onSettings: () => context.push('/profile'),
                userName: drawerProvider.user?.fullName,
                userRole: drawerProvider.user?.role.toUpperCase(),
                profileImage: drawerProvider.user?.profileImage,
                onLogout: () async {
                  await drawerProvider.logout();
                  if (context.mounted) context.go('/login');
                },
              ),
              appBar: MainAppBar(
                palette: palette,
                scale: isTablet(context) ? kTabletHeaderScale : 1.0,
                isScrolled: provider.isScrolled,
                onMenuTap: () =>
                    provider.scaffoldKey.currentState?.openDrawer(),
                onNotificationTap: () => context.push('/notifications'),
              ),
              body: Stack(
                children: [
                  HomeGlow(palette: palette),
                  ResponsiveCenter(
                    child: SingleChildScrollView(
                      controller: provider.scrollController,
                      padding: EdgeInsets.fromLTRB(
                        16,
                        MediaQuery.of(context).padding.top +
                            appBarHeight(context) +
                            8,
                        16,
                        32,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      'Hola ${drawerProvider.user?.firstName ?? ''}, ',
                                  style: GoogleFonts.poppins(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w400,
                                    color: palette.textPrimary,
                                    height: 1.2,
                                  ),
                                ),
                                TextSpan(
                                  text: provider.greeting,
                                  style: GoogleFonts.poppins(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: palette.textPrimary,
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          HomeEmptyCard(
                            palette: palette,
                            onJoinClass: () => context.push('/class'),
                          ),
                          const SizedBox(height: 28),
                          Text(
                            'QUÉ PODRÁS HACER',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: palette.textMuted,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ...provider.features.asMap().entries.map(
                            (e) => HomeFeatureItem(
                              feature: e.value,
                              palette: palette,
                              onTap: switch (e.key) {
                                0 => () => context.push('/sensors'),
                                1 => () => context.push('/fermentations'),
                                2 => () => context.push('/assistant'),
                                3 => () => context.push('/reports'),
                                _ => null,
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: BottomNavBar(
                selected: AppTab.inicio,
                palette: palette,
                onTabSelected: (tab) => onBottomNavSelected(context, tab),
              ),
            );
          },
        );
      },
    );
  }
}
