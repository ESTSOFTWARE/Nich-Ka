import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/app_theme_scope.dart';
import '../../../../shared/theme/app_palette.dart';
import '../components/calculator_input_field.dart';
import '../components/efficiency_result_card.dart';
import '../components/formula_card.dart';
import '../notifiers/calculator_notifier.dart';
import '../../../home/presentation/components/home_glow.dart';
import '../../../../core/presentation/responsive_center.dart';

class CalculatorView extends ConsumerWidget {
  const CalculatorView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculatorProvider);
    final notifier = ref.read(calculatorProvider.notifier);
    final isDark = AppThemeScope.of(context).isDark;
    final palette = AppPalette.of(isDark);
    return Scaffold(
      backgroundColor: palette.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
            onTap: () => context.canPop() ? context.pop() : context.go('/home'),
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
              'Calculadora',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: palette.textPrimary,
              ),
            ),
            Text(
              'Eficiencia (Gay-Lussac)',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: palette.textSecondary,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          HomeGlow(palette: palette),
          ResponsiveCenter(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.of(context).padding.top + kToolbarHeight + 8,
                16,
                32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormulaCard(palette: palette),
                  const SizedBox(height: 20),
                  CalculatorInputField(
                    label: 'Azúcar inicial',
                    controller: notifier.sugarController,
                    unit: 'g/L',
                    palette: palette,
                  ),
                  const SizedBox(height: 16),
                  CalculatorInputField(
                    label: 'Etanol detectado',
                    controller: notifier.ethanolController,
                    unit: '%v/v',
                    palette: palette,
                  ),
                  const SizedBox(height: 16),
                  CalculatorInputField(
                    label: 'Factor de conversión',
                    controller: notifier.factorController,
                    palette: palette,
                  ),
                  const SizedBox(height: 24),
                  EfficiencyResultCard(
                    efficiency: state.efficiency,
                    substitutedFormula: state.substitutedFormula,
                    palette: palette,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
