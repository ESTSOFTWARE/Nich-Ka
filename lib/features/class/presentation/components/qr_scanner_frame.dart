import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../shared/theme/app_palette.dart';

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
                  const _WebPlaceholder()
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
                  painter: _CornersPainter(),
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

class _WebPlaceholder extends StatelessWidget {
  const _WebPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: Center(
        child: Icon(Icons.qr_code_2, size: 120, color: Color(0x99FFFFFF)),
      ),
    );
  }
}

class _CornersPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppPalette.accent
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const len = 22.0;

    // top-left
    canvas.drawLine(const Offset(0, len), Offset.zero, paint);
    canvas.drawLine(Offset.zero, const Offset(len, 0), paint);
    // top-right
    canvas.drawLine(Offset(size.width - len, 0), Offset(size.width, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, len), paint);
    // bottom-left
    canvas.drawLine(
      Offset(0, size.height - len),
      Offset(0, size.height),
      paint,
    );
    canvas.drawLine(Offset(0, size.height), Offset(len, size.height), paint);
    // bottom-right
    canvas.drawLine(
      Offset(size.width - len, size.height),
      Offset(size.width, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height - len),
      Offset(size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(_CornersPainter old) => false;
}
