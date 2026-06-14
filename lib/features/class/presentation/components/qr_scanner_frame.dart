import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../shared/theme/app_palette.dart';
import 'qr_corners_painter.dart';
import 'qr_web_placeholder.dart';

class QrScannerFrame extends StatelessWidget {
  final AppPalette palette;
  final MobileScannerController controller;
  final void Function(String code) onDetected;

  const QrScannerFrame({
    super.key,
    required this.palette,
    required this.controller,
    required this.onDetected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 240,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (kIsWeb)
                  const QrWebPlaceholder()
                else
                  MobileScanner(
                    controller: controller,
                    onDetect: (capture) {
                      final barcode = capture.barcodes.firstOrNull;
                      final value = barcode?.rawValue;
                      if (value != null) onDetected(value);
                    },
                  ),
                CustomPaint(
                  size: const Size(190, 190),
                  painter: QrCornersPainter(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text(
              'Apunta al código QR del profesor',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Zanate
