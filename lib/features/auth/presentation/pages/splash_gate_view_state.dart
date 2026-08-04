part of 'splash_gate_view.dart';

class _SplashGateViewState extends ConsumerState<SplashGateView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _decide());
  }

  Future<void> _decide() async {
    if (!await SessionManager.instance.hasSession()) {
      _goLogin();
      return;
    }

    if (await BiometricService.isAvailable()) {
      final ok = await BiometricService.authenticate();
      if (!ok) {
        _goLogin();
        return;
      }
    }

    final token = await SessionManager.instance.restore();
    if (token == null || !mounted) {
      _goLogin();
      return;
    }

    // Solo estudiantes entran a la app móvil (admin/profesor usan la web).
    // Una sesión guardada con otro rol se descarta.
    if (token.role != 'estudiante') {
      HttpClient.instance.clearTokens();
      await SessionManager.instance.clear();
      _goLogin();
      return;
    }

    ref.read(authProvider.notifier).setUser(token);
    final route = await resolveEntryRoute();
    if (mounted) context.go(route);
  }

  void _goLogin() {
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0B),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/logo.svg', height: 64),
            const SizedBox(height: 24),
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF22C55E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
