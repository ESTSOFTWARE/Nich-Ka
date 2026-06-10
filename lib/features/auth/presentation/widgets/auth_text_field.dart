import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label del input
        Text(
          widget.label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFA3A3A3), // Equivalente a text-neutral-400
          ),
        ),
        const SizedBox(height: 6),

        // Campo de texto
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: GoogleFonts.poppins(
              color: const Color(0xFF525252), // Equivalente a text-neutral-600
            ),
            filled: true,
            fillColor: const Color(0xFF171717), // bg-neutral-900
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),

            // Borde normal
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF262626), // border-neutral-800
                width: 1,
              ),
            ),

            // Borde al hacer focus (verde)
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: const Color(0xFF22C55E).withOpacity(0.6), // focus:border-green-500/60
                width: 1,
              ),
            ),

            // Ícono del ojo (solo si es contraseña)
            suffixIcon: widget.isPassword
                ? IconButton(
              icon: SvgPicture.asset(
                _obscureText
                    ? 'assets/img/eye-slash.svg' // eye-slash.svg
                    : 'assets/img/eye.svg',       // eye.svg
                colorFilter: const ColorFilter.mode(
                  Color(0xFF525252),
                  BlendMode.srcIn,
                ),
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
                : null,
          ),
        ),
      ],
    );
  }
}