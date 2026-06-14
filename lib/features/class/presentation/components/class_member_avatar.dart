import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClassMemberAvatar extends StatelessWidget {
  final String initials;
  final Color color;
  final Color borderColor;
  final double size;

  const ClassMemberAvatar({
    super.key,
    required this.initials,
    required this.color,
    required this.borderColor,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Text(
        initials,
        style: GoogleFonts.poppins(
          fontSize: size * 0.33,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
