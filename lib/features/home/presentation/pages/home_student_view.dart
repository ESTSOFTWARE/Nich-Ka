import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import '../../../../core/presentation/change_notifier_provider.dart' as core;
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
import '../notifiers/home_student_notifier.dart';

class HomeStudentView extends ConsumerStatefulWidget {
  const HomeStudentView({super.key});

  @override
  ConsumerState<HomeStudentView> createState() => _HomeStudentViewState();
}

class _HomeStudentViewState extends ConsumerState<HomeStudentView> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = _scrollController.offset > 4;
    if (scrolled != _isScrolled) setState(() => _isScrolled = scrolled);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(homeStudentProvider.notifier);
    final isDark = AppThemeScope.of(context).isDark;
    final palette = AppPalette.of(isDark);
    return core.ChangeNotifierProvider<DrawerProvider>(
      create: () => DrawerProvider(),
      builder: (context, drawerProvider) {
        return Scaffold(
          key: _scaffoldKey,
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
            isScrolled: _isScrolled,
            onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
            onNotificationTap: () => context.push('/notifications'),
          ),
          body: Stack(
            children: [
              HomeGlow(palette: palette),
              SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.fromLTRB(
                  16,
                  MediaQuery.of(context).padding.top + kToolbarHeight + 8,
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
                            text: notifier.greeting,
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
                    ...notifier.features.asMap().entries.map(
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
  }
}
