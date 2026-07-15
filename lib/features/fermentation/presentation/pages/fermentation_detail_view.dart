import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import '../components/fermentation_detail_chart_card.dart';
import '../components/fermentation_detail_metrics_grid.dart';
import '../components/fermentation_detail_status_card.dart';
import '../components/fermentation_events_section.dart';
import '../components/fermentation_info_banner.dart';
import '../notifiers/fermentation_detail_notifier.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../../home/presentation/components/home_glow.dart';

class FermentationDetailView extends ConsumerStatefulWidget {
  const FermentationDetailView({super.key});

  @override
  ConsumerState<FermentationDetailView> createState() =>
      _FermentationDetailViewState();
}

class _FermentationDetailViewState
    extends ConsumerState<FermentationDetailView> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(fermentationDetailProvider.notifier).load();
    });
  }

  void _onScroll() {
    final scrolled = _scrollController.offset > 4;
    if (scrolled != _isScrolled) {
      setState(() => _isScrolled = scrolled);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(fermentationDetailProvider);
    final notifier = ref.read(fermentationDetailProvider.notifier);
    final detail = notifier.detail;
    final isDark = AppThemeScope.of(context).isDark;
    final palette = AppPalette.of(isDark);
    return Scaffold(
      backgroundColor: palette.background,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: _isScrolled ? 20 : 0,
              sigmaY: _isScrolled ? 20 : 0,
            ),
            child: AppBar(
              backgroundColor: _isScrolled
                  ? palette.glassBackground
                  : Colors.transparent,
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
                  onTap: () => context.canPop()
                      ? context.pop()
                      : context.go('/fermentations'),
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
                    detail.title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: palette.textPrimary,
                    ),
                  ),
                  Text(
                    detail.subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
              actions: [
                Center(
                  child: Container(
                    width: 36,
                    height: 36,
                    margin: const EdgeInsets.only(right: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: palette.border),
                    ),
                    child: Icon(
                      Icons.more_horiz,
                      color: palette.textPrimary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
                FermentationDetailStatusCard(detail: detail, palette: palette),
                const SizedBox(height: 12),
                FermentationDetailChartCard(
                  points: detail.chartPoints,
                  palette: palette,
                ),
                const SizedBox(height: 12),
                FermentationDetailMetricsGrid(detail: detail, palette: palette),
                const SizedBox(height: 12),
                FermentationInfoBanner(palette: palette),
                const SizedBox(height: 24),
                FermentationEventsSection(
                  events: detail.events,
                  palette: palette,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
