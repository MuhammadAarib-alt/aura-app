import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuraTheme {
  // ── Palette ──────────────────────────────────────────────
  static const Color bg        = Color(0xFF0A0C12);
  static const Color surface   = Color(0xFF12151E);
  static const Color card      = Color(0xFF181C28);
  static const Color border    = Color(0xFF222638);
  static const Color accent    = Color(0xFF7EE8A2); // mint green
  static const Color accent2   = Color(0xFF5B8DEF); // blue
  static const Color accent3   = Color(0xFFF4A261); // warm orange
  static const Color textPrim  = Color(0xFFE8EAF0);
  static const Color textSec   = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF3D4255);

  // ── Gradients ─────────────────────────────────────────────
  static const LinearGradient accentGrad = LinearGradient(
    colors: [Color(0xFF7EE8A2), Color(0xFF5B8DEF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bgGrad = LinearGradient(
    colors: [Color(0xFF0A0C12), Color(0xFF0D1020)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ── Theme ─────────────────────────────────────────────────
  static ThemeData get theme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bg,
    colorScheme: const ColorScheme.dark(
      background: bg,
      surface: surface,
      primary: accent,
      secondary: accent2,
    ),
    textTheme: GoogleFonts.spaceGroteskTextTheme(
      const TextTheme(
        displayLarge: TextStyle(color: textPrim, fontWeight: FontWeight.w700, letterSpacing: -1.5),
        displayMedium: TextStyle(color: textPrim, fontWeight: FontWeight.w700, letterSpacing: -1.0),
        headlineLarge: TextStyle(color: textPrim, fontWeight: FontWeight.w700, letterSpacing: -0.5),
        headlineMedium: TextStyle(color: textPrim, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: textPrim, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: textSec, height: 1.6),
        bodyMedium: TextStyle(color: textSec, height: 1.5),
        labelLarge: TextStyle(color: textPrim, fontWeight: FontWeight.w600, letterSpacing: 0.5),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: bg,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: textPrim,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: textPrim),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: bg,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: border, width: 1),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: accent, width: 1.5),
      ),
      labelStyle: const TextStyle(color: textSec),
      hintStyle: const TextStyle(color: textMuted),
    ),
  );
}
