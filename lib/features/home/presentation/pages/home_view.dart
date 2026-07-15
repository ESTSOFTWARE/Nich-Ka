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
import '../components/active_fermentation_card.dart';
import '../components/ai_recommendation_card.dart';
import '../components/fermentation_list_item.dart';
import '../components/home_glow.dart';
import '../components/predict_button.dart';
import '../notifiers/home_notifier.dart';
import '../../../../shared/theme/app_palette.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeProvider.notifier).load();
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
    final state = ref.watch(homeProvider);
    final notifier = ref.read(homeProvider.notifier);
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
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: firstName.isEmpty
                                ? 'Hola, '
                                : 'Hola $firstName, ',
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
                    ActiveFermentationCard(
                      fermentation: state.active,
                      palette: palette,
                      elapsedFormatted: notifier.elapsedFormatted,
                      objectiveFormatted: notifier.objectiveFormatted,
                    ),
                    const SizedBox(height: 10),
                    PredictButton(
                      isLoading: state.isPredicting,
                      onTap: () =>
                          ref.read(homeProvider.notifier).requestPrediction(),
                    ),
                    const SizedBox(height: 10),
                    AiRecommendationCard(
                      recommendation: state.recommendation,
                      palette: palette,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tus fermentaciones',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: palette.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.push('/fermentations'),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Ver todo →',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: palette.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...state.fermentations.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: FermentationListItem(
                          item: item,
                          palette: palette,
                          onTap: item.sessionId != null
                              ? () => context.push(
                                  '/report-detail',
                                  extra: item.sessionId,
                                )
                              : null,
                        ),
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

