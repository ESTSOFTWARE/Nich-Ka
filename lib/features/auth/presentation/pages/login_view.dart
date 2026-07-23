import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/presentation/responsive.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/navigation/entry_route.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../notifiers/login_notifier.dart';
import '../states/ui_state.dart';
import '../components/legal_footer.dart';
import '../components/social_login_button.dart';
import '../components/spotlight_background.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  Future<void> _loginWithGoogle(BuildContext context, WidgetRef ref) async {
    final ok = await ref.read(loginProvider.notifier).loginWithGoogle();
    if (!context.mounted) return;
    if (!ok) {
      final loginState = ref.read(loginProvider);
      final msg = loginState.status is UiError
          ? (loginState.status as UiError).message
          : 'No se pudo iniciar sesión con Google.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      return;
    }
    final token = ref.read(loginProvider).token;
    if (token != null) {
      context.read<AuthProvider>().setUser(token);
    }
    final code = pendingJoinCode;
    if (code != null) {
      pendingJoinCode = null;
      context.go('/join?code=$code');
    } else {
      final route = await resolveEntryRoute();
      if (context.mounted) context.go(route);
    }
  }

  Widget _header({double scale = 1}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        'Nich-Ká',
        style: GoogleFonts.poppins(
          fontSize: 24 * scale,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
      ),
      SvgPicture.asset('assets/icons/logo.svg', height: 40 * scale),
    ],
  );

  Widget _title() => Text(
    'Comienza tu experiencia',
    textAlign: TextAlign.center,
    style: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
      height: 1.2,
    ),
  );

  Widget _subtitle() => Text(
    'Un sistema automatizado que optimiza y controla la fermentación del café para obtener perfiles de sabor únicos y consistentes.',
    textAlign: TextAlign.center,
    style: GoogleFonts.poppins(
      fontSize: 14,
      color: AppColors.textSecondary,
      height: 1.5,
    ),
  );

  List<Widget> _buttons(BuildContext context, WidgetRef ref) => [
    SocialLoginButton(
      text: 'Continuar con Google',
      iconPath: 'assets/icons/google.svg',
      onPressed: () => _loginWithGoogle(context, ref),
    ),
    const SizedBox(height: 16),
    SocialLoginButton(
      text: 'Continuar con Correo',
      iconPath: 'assets/icons/gmail.svg',
      onPressed: () => context.go('/login-email'),
    ),
  ];

  /// Layout original de teléfono: ilustración arriba, contenido abajo.
  /// En tablet vertical se reusa con la ilustración más grande para que no
  /// se vea perdida en una pantalla alta.
  Widget _phoneLayout(
    BuildContext context,
    WidgetRef ref, {
    double imageHeight = 250,
    bool includeHeader = true,
  }) => Column(
    children: [
      const SizedBox(height: 16),
      if (includeHeader) _header(),
      const Spacer(),
      Image.asset(
        'assets/img/nich-ka-animado.png',
        height: imageHeight,
        fit: BoxFit.contain,
      ),
      const Spacer(),
      _title(),
      const SizedBox(height: 12),
      _subtitle(),
      const SizedBox(height: 48),
      ..._buttons(context, ref),
      const SizedBox(height: 32),
      const LegalFooter(),
      const SizedBox(height: 16),
    ],
  );

  /// Tablet horizontal: ilustración a la izquierda, contenido a la derecha.
  Widget _tabletLayout(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const SizedBox(height: 24),
        _header(scale: kTabletHeaderScale),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/img/nich-ka-animado.png',
                    height: 340,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _title(),
                        const SizedBox(height: 16),
                        _subtitle(),
                        const SizedBox(height: 40),
                        ..._buttons(context, ref),
                        const SizedBox(height: 32),
                        const LegalFooter(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tablet = isTablet(context);
    // Dos columnas solo en tablet HORIZONTAL. En tablet vertical se usa el
    // layout del teléfono (imagen arriba, botones abajo), centrado a un
    // ancho cómodo para que no se estire de borde a borde.
    final sideBySide = tablet && isLandscape(context);
    if (!tablet) {
      return SpotlightBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: _phoneLayout(context, ref),
        ),
      );
    }

    // Tablet: mismo escalado de texto que el resto de la app.
    return SpotlightBackground(
      child: MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: const TextScaler.linear(kTabletTextScale)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: sideBySide ? 48.0 : kTabletPadding,
          ),
          child: sideBySide
              ? _tabletLayout(context, ref)
              // Vertical: el header ocupa todo el ancho (nombre a la
              // izquierda, logo a la derecha) y el contenido se centra.
              : Column(
                  children: [
                    const SizedBox(height: 24),
                    _header(scale: kTabletHeaderScale),
                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: kTabletMaxWidth,
                          ),
                          child: _phoneLayout(
                            context,
                            ref,
                            imageHeight: 420,
                            includeHeader: false,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
