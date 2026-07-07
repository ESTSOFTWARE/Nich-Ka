import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClassMemberAvatar extends StatelessWidget {
  final String initials;
  final Color color;
  final Color borderColor;
  final double size;
  final String? avatar;

  const ClassMemberAvatar({
    super.key,
    required this.initials,
    required this.color,
    required this.borderColor,
    this.size = 36,
    this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    final initialsChild = Text(
      initials,
      style: GoogleFonts.poppins(
        fontSize: size * 0.33,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
      ),
      child: (avatar == null || avatar!.isEmpty)
          ? initialsChild
          : ClipOval(
              child: Image.network(
                avatar!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => initialsChild,
              ),
            ),
    );
  }
}
