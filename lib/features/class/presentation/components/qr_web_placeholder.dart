import 'package:flutter/material.dart';

class QrWebPlaceholder extends StatelessWidget {
  const QrWebPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: Center(
        child: Icon(Icons.qr_code_2, size: 120, color: Color(0x99FFFFFF)),
      ),
    );
  }
}
