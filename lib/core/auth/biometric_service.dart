import 'package:local_auth/local_auth.dart';

/// Autenticación biométrica (huella / rostro).
class BiometricService {
  BiometricService._();
  static final LocalAuthentication _auth = LocalAuthentication();

  /// ¿El dispositivo tiene huella/rostro configurado y disponible?
  static Future<bool> isAvailable() async {
    try {
      final supported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      return supported && canCheck;
    } catch (_) {
      return false;
    }
  }

  /// Pide la huella. true si el usuario se autenticó.
  static Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Usa tu huella para entrar a Nich-Ká',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
