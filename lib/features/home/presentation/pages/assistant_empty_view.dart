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
import '../../../../shared/utils/drawer_navigation.dart';
import '../../../../shared/utils/bottom_nav_navigation.dart';
import '../../../../features/profile/presentation/providers/drawer_provider.dart';
import '../components/ai_message_card.dart';
import '../components/assistant_empty_state.dart';
import '../components/home_glow.dart';
import '../providers/assistant_provider.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../../../core/presentation/responsive.dart';

class AssistantEmptyView extends StatelessWidget {
  const AssistantEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AssistantProvider>(
      create: () => AssistantProvider(),
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
                selected: AppDrawerItem.asistente,
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
              ),
              body: Stack(
                children: [
                  HomeGlow(palette: palette),
                  SingleChildScrollView(
                    controller: provider.scrollController,
                    padding: EdgeInsets.fromLTRB(
                      16,
                      MediaQuery.of(context).padding.top +
                          appBarHeight(context) +
                          8,
                      16,
                      24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    'Hola ${drawerProvider.user?.firstName ?? ''}, ',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: palette.textPrimary,
                                  height: 1.2,
                                ),
                              ),
                              TextSpan(
                                text: provider.greeting,
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: palette.textPrimary,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        AiMessageCard(
                          palette: palette,
                          hasActiveFermentation: false,
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: AssistantEmptyState(palette: palette),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: BottomNavBar(
                selected: AppTab.asistente,
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
