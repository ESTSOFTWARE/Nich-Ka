part of 'login_email_view.dart';

class _LoginEmailViewState extends ConsumerState<LoginEmailView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _navigateAfterLogin() async {
    final token = ref.read(loginProvider).token;
    if (token != null && mounted) {
      context.read<AuthProvider>().setUser(token);
    }
    final code = pendingJoinCode;
    if (code != null) {
      pendingJoinCode = null;
      if (mounted) context.go('/join?code=$code');
    } else {
      final route = await resolveEntryRoute();
      if (mounted) context.go(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);

    return SpotlightBackground(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nich-Ká',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SvgPicture.asset('assets/icons/logo.svg', height: 40),
                ],
              ),
              const SizedBox(height: 60),

              Text(
                '¡Bienvenido de nuevo!',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Monitorea y optimiza la fermentación de tu café con inteligencia artificial en tiempo real.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 48),

              AuthTextField(
                label: 'Correo electrónico',
                hintText: 'tu@ejemplo.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                maxLength: 254,
                validator: Validators.email,
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AuthFieldLabel(text: 'Contraseña'),
                  GestureDetector(
                    onTap: () => context.push('/forgot-password'),
                    child: Text(
                      '¿Olvidaste tu contraseña?',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              AuthTextField(
                label: '',
                hintText: '••••••••',
                controller: _passwordController,
                isPassword: true,
                isObscured: loginState.isPasswordObscured,
                onToggleObscure: () =>
                    ref.read(loginProvider.notifier).togglePasswordVisibility(),
                validator: Validators.loginPassword,
              ),

              const SizedBox(height: 48),

              if (loginState.status is UiError)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    (loginState.status as UiError).message,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.redAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              PrimaryAuthButton(
                text: 'Iniciar Sesión',
                iconPath: 'assets/icons/login.svg',
                filled: false,
                isLoading: loginState.status is UiLoading,
                onPressed: () async {
                  if (!(_formKey.currentState?.validate() ?? false)) return;
                  final ok = await ref
                      .read(loginProvider.notifier)
                      .loginWithEmail(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );
                  if (ok) await _navigateAfterLogin();
                },
              ),
              const SizedBox(height: 24),

              SocialLoginButton(
                text: 'Iniciar con Google',
                iconPath: 'assets/icons/google.svg',
                onPressed: () async {
                  final ok = await ref
                      .read(loginProvider.notifier)
                      .loginWithGoogle();
                  if (ok) await _navigateAfterLogin();
                },
              ),

              const SizedBox(height: 32),
              const Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 28),

              const LegalFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
