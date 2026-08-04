import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_palette.dart';
import '../../../home/presentation/components/home_glow.dart';
import '../../domain/entities/simulator_model_type.dart';
import '../components/simulator_chart.dart';
import '../components/simulator_model_selector.dart';
import '../components/simulator_param_slider.dart';
import '../components/simulator_section_header.dart';
import '../components/simulator_stats_row.dart';
import '../notifiers/simulator_notifier.dart';
import '../../../../core/presentation/responsive_center.dart';
import '../../../../core/presentation/responsive.dart';

class SimulatorView extends ConsumerWidget {
  const SimulatorView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(simulatorProvider);
    final notifier = ref.read(simulatorProvider.notifier);
    final isDark = AppThemeScope.of(context).isDark;
    final palette = AppPalette.of(isDark);
    return Scaffold(
      backgroundColor: palette.background,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          (kToolbarHeight) * (isTablet(context) ? kTabletHeaderScale : 1.0),
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: state.isScrolled ? 20 : 0,
              sigmaY: state.isScrolled ? 20 : 0,
            ),
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(
                  isTablet(context) ? kTabletTextScale : 1,
                ),
              ),
              child: AppBar(
                backgroundColor: state.isScrolled
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
                      'Simulador',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: palette.textPrimary,
                      ),
                    ),
                    Text(
                      'Cinética de fermentación',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppPalette.accent),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'PEDAGÓGICO',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppPalette.accent,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          HomeGlow(palette: palette),
          ResponsiveCenter(
            child: SingleChildScrollView(
              controller: notifier.scrollController,
              padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.of(context).padding.top +
                    (kToolbarHeight + 8) *
                        (isTablet(context) ? kTabletHeaderScale : 1.0),
                16,
                32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SimulatorModelSelector(
                    selected: state.model,
                    palette: palette,
                    onSelected: notifier.setModel,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                    decoration: BoxDecoration(
                      color: palette.aiCardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: palette.aiCardBorder),
                    ),
                    child: Column(
                      children: [
                        SimulatorStatsRow(
                          efficiency: state.efficiency,
                          finalProduct: state.finalProduct,
                          palette: palette,
                        ),
                        const SizedBox(height: 16),
                        SimulatorChart(points: state.points, palette: palette),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SimulatorSectionHeader(label: 'CINÉTICA', palette: palette),
                  _card(
                    palette: palette,
                    children: [
                      SimulatorParamSlider(
                        symbol: 'μ',
                        subscript: 'max',
                        description: 'Tasa máx. de crecimiento',
                        value: state.muMax,
                        min: 0.01,
                        max: 0.5,
                        unit: '1/h',
                        decimals: 3,
                        palette: palette,
                        onChanged: notifier.setMuMax,
                      ),
                      _divider(palette),
                      SimulatorParamSlider(
                        symbol: 'K',
                        subscript: 's',
                        description: 'Constante de saturación',
                        value: state.ks,
                        min: 1.0,
                        max: 50.0,
                        unit: 'g/L',
                        decimals: 1,
                        palette: palette,
                        onChanged: notifier.setKs,
                      ),
                      if (state.model != SimulatorModelType.monod) ...[
                        _divider(palette),
                        SimulatorParamSlider(
                          symbol: 'X',
                          subscript: 'm',
                          description: 'Biomasa máxima',
                          value: state.xm,
                          min: 1.0,
                          max: 20.0,
                          unit: 'g/L',
                          decimals: 1,
                          palette: palette,
                          onChanged: notifier.setXm,
                        ),
                      ],
                    ],
                  ),
                  SimulatorSectionHeader(
                    label: 'RENDIMIENTOS',
                    palette: palette,
                  ),
                  _card(
                    palette: palette,
                    children: [
                      SimulatorParamSlider(
                        symbol: 'Y',
                        subscript: 'xs',
                        description: 'Rendimiento biomasa/sustrato',
                        value: state.yxs,
                        min: 0.1,
                        max: 1.0,
                        unit: '',
                        decimals: 2,
                        palette: palette,
                        onChanged: notifier.setYxs,
                      ),
                      _divider(palette),
                      SimulatorParamSlider(
                        symbol: 'Y',
                        subscript: 'ps',
                        description: 'Rendimiento producto/sustrato',
                        value: state.yps,
                        min: 0.1,
                        max: 1.0,
                        unit: '',
                        decimals: 2,
                        palette: palette,
                        onChanged: notifier.setYps,
                      ),
                    ],
                  ),
                  SimulatorSectionHeader(
                    label: 'CONDICIONES INICIALES',
                    palette: palette,
                  ),
                  _card(
                    palette: palette,
                    children: [
                      SimulatorParamSlider(
                        symbol: 'X',
                        subscript: '₀',
                        description: 'Biomasa inicial',
                        value: state.x0,
                        min: 0.01,
                        max: 2.0,
                        unit: 'g/L',
                        decimals: 2,
                        palette: palette,
                        onChanged: notifier.setX0,
                      ),
                      _divider(palette),
                      SimulatorParamSlider(
                        symbol: 'S',
                        subscript: '₀',
                        description: 'Sustrato inicial',
                        value: state.s0,
                        min: 10.0,
                        max: 500.0,
                        unit: 'g/L',
                        decimals: 0,
                        palette: palette,
                        onChanged: notifier.setS0,
                      ),
                      _divider(palette),
                      SimulatorParamSlider(
                        symbol: 't',
                        subscript: 'f',
                        description: 'Tiempo de fermentación',
                        value: state.tf,
                        min: 50.0,
                        max: 500.0,
                        unit: 'h',
                        decimals: 0,
                        palette: palette,
                        onChanged: notifier.setTf,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required AppPalette palette, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: palette.aiCardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.aiCardBorder),
      ),
      child: Column(children: children),
    );
  }

  Widget _divider(AppPalette palette) {
    return Divider(color: palette.border, height: 1);
  }
}
