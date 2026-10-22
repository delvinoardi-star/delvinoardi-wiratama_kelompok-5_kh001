import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class C {
  static const primary = Color(0xFF1D8052);
  static const dark = Color(0xFF123F2C);
  static const ink = Color(0xFF14261D);
  static const bg = Color(0xFFF3F8F2);
  static const amber = Color(0xFFFBB731);
  static const danger = Color(0xFFD63A3A);
  static const muted = Color(0xFF5F6F65);
  static const border = Color(0xFFDCE8E0);
  static const soft = Color(0xFFE1F1E6);
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: C.primary,
    scaffoldBackgroundColor: C.bg,
  );
  return base.copyWith(
    textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme)
        .apply(bodyColor: C.ink, displayColor: C.ink),
  );
}
