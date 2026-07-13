class Validators {
  Validators._();

  static final _emailRe = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
  static final _nameRe = RegExp(r"^[A-Za-zÀ-ÿ' .-]+$");
  static final _letterRe = RegExp(r'[A-Za-zÀ-ÿ]');
  static final _digitRe = RegExp(r'\d');

  static String? Function(String?) combine(
    List<String? Function(String?)> rules,
  ) {
    return (value) {
      for (final rule in rules) {
        final error = rule(value);
        if (error != null) return error;
      }
      return null;
    };
  }

  static String? Function(String?) required([String field = 'Este campo']) =>
      (v) => (v == null || v.trim().isEmpty) ? '$field es obligatorio' : null;

  static String? Function(String?) minLength(
    int n, [
    String field = 'Este campo',
  ]) =>
      (v) => (v ?? '').trim().length < n
      ? '$field debe tener al menos $n caracteres'
      : null;

  static String? Function(String?) maxLength(
    int n, [
    String field = 'Este campo',
  ]) =>
      (v) =>
          (v ?? '').length > n ? '$field no puede superar $n caracteres' : null;

  static String? Function(String?) range(num min, num max) => (v) {
    final n = num.tryParse((v ?? '').trim());
    if (n == null) return 'Debe ser un número';
    if (n < min || n > max) return 'Debe estar entre $min y $max';
    return null;
  };

  static String? email(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'El correo es obligatorio';
    if (value.length > 254 || !_emailRe.hasMatch(value)) {
      return 'Correo no válido';
    }
    return null;
  }

  static String? password(String? v) {
    final value = v ?? '';
    if (value.isEmpty) return 'La contraseña es obligatoria';
    if (value.length < 8) return 'Mínimo 8 caracteres';
    if (!_letterRe.hasMatch(value) || !_digitRe.hasMatch(value)) {
      return 'Debe incluir letras y números';
    }
    return null;
  }

  static String? loginPassword(String? v) =>
      (v == null || v.isEmpty) ? 'La contraseña es obligatoria' : null;

  static String? personName(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Obligatorio';
    if (value.length < 2) return 'Muy corto';
    if (value.length > 50) return 'Máximo 50 caracteres';
    if (!_nameRe.hasMatch(value)) return 'Solo letras';
    return null;
  }
}
