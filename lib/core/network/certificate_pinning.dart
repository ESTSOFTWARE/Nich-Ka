import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/io_client.dart';

class CertificatePinningException implements Exception {
  final String message;

  const CertificatePinningException([
    this.message =
        'No se pudo verificar la identidad del servidor. La conexión fue '
        'bloqueada por seguridad: el certificado recibido no coincide con '
        'el certificado de confianza de Nich-Ká (posible interceptación '
        'del tráfico).',
  ]);

  @override
  String toString() => message;
}

class PinnedClientFactory {
  PinnedClientFactory._();

  static const List<String> _pinnedCertAssets = [
    'assets/certs/pinned/api_nichka_current.pem',
  ];

  static const List<String> pinnedSha256Fingerprints = [
    'a893cbc1280262ab0d4f81fd45a07087676f8c8639d88f5cf9640cddfdbb7311',
  ];

  static IOClient? _cached;

  static Future<IOClient> get client async => _cached ??= await _build();

  static Future<IOClient> _build() async {
    final context = SecurityContext(withTrustedRoots: false);

    for (final assetPath in _pinnedCertAssets) {
      final bytes = (await rootBundle.load(assetPath)).buffer.asUint8List();
      final content = String.fromCharCodes(bytes);

      if (content.contains('PLACEHOLDER, REEMPLAZAR')) {
        throw StateError(
          'SSL Pinning mal configurado: "$assetPath" sigue siendo el '
          'certificado de ejemplo. Reemplázalo por el certificado real de '
          'api.nich-ka.space (ver README_PINNING.md) antes de compilar la '
          'app.',
        );
      }

      context.setTrustedCertificatesBytes(bytes);
    }

    final httpClient = HttpClient(context: context);

    httpClient.badCertificateCallback = (cert, host, port) {
      final fingerprint = sha256.convert(cert.der).toString();
      print(
        '[SSL Pinning] Certificado NO confiable rechazado para $host:$port '
        '(SHA-256 recibido: $fingerprint)',
      );
      return false;
    };

    return IOClient(httpClient);
  }

  static void reset() => _cached = null;
}
