import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/app_palette.dart';
import 'quick_action_button.dart';

class QuickActionsRow extends StatelessWidget {
  final AppPalette palette;

  const QuickActionsRow({super.key, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: QuickActionButton(
            palette: palette,
            label: 'Comparar',
            icon: SvgPicture.asset(
              'assets/icons/compare.svg',
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(
                palette.textPrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: QuickActionButton(
            palette: palette,
            label: 'Escanear',
            icon: SvgPicture.asset(
              'assets/icons/scan.svg',
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(
                palette.textPrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: QuickActionButton(
            palette: palette,
            label: 'Reporte',
            onTap: () => context.push('/reports'),
            icon: SvgPicture.asset(
              'assets/icons/report.svg',
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(
                palette.textPrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
