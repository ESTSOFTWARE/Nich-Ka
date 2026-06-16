import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClassDetailHeroCard extends StatelessWidget {
  final String badgeLabel;
  final String? coverImage;

  const ClassDetailHeroCard({
    super.key,
    required this.badgeLabel,
    this.coverImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF3D2010), Color(0xFF1C0A04)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (coverImage != null)
            Image.network(
              coverImage!,
              fit: BoxFit.cover,
              errorBuilder: (_, e, s) => const SizedBox.shrink(),
            ),
          if (coverImage == null) ...[
            Positioned(
              right: -40,
              top: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                    width: 40,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 20,
              bottom: -60,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.04),
                    width: 30,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 16,
              child: Image.asset(
                'assets/img/nich-ka-animado.png',
                height: 80,
                opacity: const AlwaysStoppedAnimation(0.18),
              ),
            ),
          ],
          Positioned(
            top: 14,
            right: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
              ),
              child: Text(
                badgeLabel,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
