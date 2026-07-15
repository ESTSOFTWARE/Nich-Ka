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
import '../../../../shared/utils/drawer_navigation.dart';
import '../../../../shared/utils/bottom_nav_navigation.dart';
import '../../../../features/profile/presentation/providers/drawer_provider.dart';
import '../components/fermentation_curve_card.dart';
import '../components/fermentation_progress_list.dart';
import '../components/home_glow.dart';
import '../components/stats_overview_grid.dart';
import '../notifiers/overview_notifier.dart';
import '../../../../shared/theme/app_palette.dart';

class OverviewView extends ConsumerStatefulWidget {
  const OverviewView({super.key});

  @override
  ConsumerState<OverviewView> createState() => _OverviewViewState();
}

class _OverviewViewState extends ConsumerState<OverviewView> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(overviewProvider.notifier).load();
    });
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
    final state = ref.watch(overviewProvider);
    final notifier = ref.read(overviewProvider.notifier);
    if (!state.isLoading && !notifier.hasActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go('/');
      });
      return const Scaffold(
        backgroundColor: Color(0xFF0A0A0B),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final isDark = AppThemeScope.of(context).isDark;
    final palette = AppPalette.of(isDark);
    return core.ChangeNotifierProvider<DrawerProvider>(
      create: () => DrawerProvider(),
      builder: (context, drawerProvider) {
        final firstName = (drawerProvider.user?.fullName ?? '')
            .trim()
            .split(' ')
            .first;
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
                            text: firstName.isEmpty
                                ? 'Hola, '
                                : 'Hola $firstName, ',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              color: palette.textPrimary,
                              height: 1.2,
                            ),
                          ),
                          TextSpan(
                            text: notifier.greeting,
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
                    StatsOverviewGrid(stats: state.stats, palette: palette),
                    const SizedBox(height: 14),
                    FermentationCurveCard(
                      points: notifier.chartPoints,
                      selectedRange: state.selectedRange,
                      palette: palette,
                      onRangeSelected: (r) =>
                          ref.read(overviewProvider.notifier).selectRange(r),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'FERMENTACIONES',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: palette.textMuted,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    FermentationProgressList(
                      cards: state.fermentationCards,
                      palette: palette,
                      total: state.fermentationCards.length,
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
