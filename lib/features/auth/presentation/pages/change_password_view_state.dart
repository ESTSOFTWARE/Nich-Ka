part of 'change_password_view.dart';

class _ChangePasswordViewState extends ConsumerState<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cpState = ref.watch(changePasswordProvider);
    final status = cpState.status;

    return SpotlightBackground(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleIconButton(
                icon: Icons.arrow_back_ios_new,
                backgroundColor: AppColors.surface,
                borderColor: AppColors.border,
                iconColor: AppColors.textPrimary,
                onTap: () =>
                    context.canPop() ? context.pop() : context.go('/profile'),
              ),
              const SizedBox(height: 32),

              Text(
                'Cambiar contraseña',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ingresa tu contraseña actual y define una nueva para proteger tu cuenta.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              AuthTextField(
                label: 'Contraseña actual',
                hintText: '••••••••',
                controller: _currentController,
                isPassword: true,
                isObscured: cpState.currentObscured,
                onToggleObscure: () => ref
                    .read(changePasswordProvider.notifier)
                    .toggleCurrentObscured(),
                validator: Validators.loginPassword,
              ),
              const SizedBox(height: 24),

              AuthTextField(
                label: 'Nueva contraseña',
                hintText: '••••••••',
                controller: _newController,
                isPassword: true,
                isObscured: cpState.newObscured,
                onToggleObscure: () => ref
                    .read(changePasswordProvider.notifier)
                    .toggleNewObscured(),
                validator: Validators.password,
              ),
              const SizedBox(height: 24),

              AuthTextField(
                label: 'Confirmar contraseña',
                hintText: '••••••••',
                controller: _confirmController,
                isPassword: true,
                isObscured: cpState.confirmObscured,
                onToggleObscure: () => ref
                    .read(changePasswordProvider.notifier)
                    .toggleConfirmObscured(),
                validator: (v) => v != _newController.text
                    ? 'Las contraseñas no coinciden'
                    : null,
              ),

              if (status is UiError) ...[
                const SizedBox(height: 16),
                Text(
                  status.message,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.error,
                  ),
                ),
              ],
              if (status is UiSuccess) ...[
                const SizedBox(height: 16),
                Text(
                  'Tu contraseña se actualizó correctamente.',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.accent,
                  ),
                ),
              ],

              const SizedBox(height: 40),

              PrimaryAuthButton(
                text: 'Guardar cambios',
                isLoading: status is UiLoading,
                onPressed: () async {
                  if (!(_formKey.currentState?.validate() ?? false)) return;
                  await ref
                      .read(changePasswordProvider.notifier)
                      .submit(
                        current: _currentController.text.trim(),
                        next: _newController.text.trim(),
                        confirm: _confirmController.text.trim(),
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
