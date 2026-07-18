part of 'splash_gate_view.dart';

class _SplashGateViewState extends State<SplashGateView> {
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

    context.read<AuthProvider>().setUser(token);
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
