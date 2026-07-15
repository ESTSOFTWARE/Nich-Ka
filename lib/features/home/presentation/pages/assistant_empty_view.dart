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
import '../components/ai_message_card.dart';
import '../components/assistant_empty_state.dart';
import '../components/home_glow.dart';
import '../notifiers/assistant_notifier.dart';
import '../../../../shared/theme/app_palette.dart';

class AssistantEmptyView extends ConsumerStatefulWidget {
  const AssistantEmptyView({super.key});

  @override
  ConsumerState<AssistantEmptyView> createState() => _AssistantEmptyViewState();
}

class _AssistantEmptyViewState extends ConsumerState<AssistantEmptyView> {
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
    final notifier = ref.read(assistantProvider.notifier);
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
            isScrolled: _isScrolled,
            onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
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
  }
}
