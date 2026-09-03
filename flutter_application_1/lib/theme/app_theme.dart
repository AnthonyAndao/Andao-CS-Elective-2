import 'package:flutter/material.dart';

/// Central theme definition for SoleMate.
///
/// Everything visual (colors, type scale, button shapes, card shapes) is
/// defined ONCE here and applied at the MaterialApp level via
/// `theme:` / `darkTheme:`. Screens and widgets never hardcode a color —
/// they pull from `Theme.of(context)` instead. This satisfies the
/// "single ThemeData, no scattered hardcoded colors" requirement.
class AppTheme {
  AppTheme._();

  static const Color _plum900 = Color(0xFF120A1F); 
  static const Color _plum700 = Color(0xFF1E1330); 
  static const Color _violet600 = Color(0xFF6C3FC5); 
  static const Color _violet400 = Color(0xFFA98BF0); 
  static const Color _ink900 = Color(0xFF1A1523); 
  static const Color _sand50 = Color(0xFFF6F3FA); 
  static const Color _cardLight = Color(0xFFFFFFFF);

  static const String _fontFamily = 'Roboto'; // Flutter default, kept explicit

  static ThemeData get light => _build(
        brightness: Brightness.light,
        background: _sand50,
        surface: _cardLight,
        primary: _violet600,
        onPrimary: Colors.white,
        textColor: _ink900,
        subtleText: _ink900.withOpacity(0.62),
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        background: _plum900,
        surface: _plum700,
        primary: _violet400,
        onPrimary: _plum900,
        textColor: const Color(0xFFF3EEFB),
        subtleText: const Color(0xFFF3EEFB).withOpacity(0.64),
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color primary,
    required Color onPrimary,
    required Color textColor,
    required Color subtleText,
  }) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      secondary: primary,
      onSecondary: onPrimary,
      error: const Color(0xFFCF4B4B),
      onError: Colors.white,
      surface: surface,
      onSurface: textColor,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      fontFamily: _fontFamily,

      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textColor,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),

      textTheme: TextTheme(
        headlineSmall: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w800,
          fontSize: 26,
          letterSpacing: -0.3,
        ),
        titleMedium: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: subtleText,
          fontSize: 14,
          height: 1.35,
        ),
        labelLarge: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),

      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: textColor.withOpacity(0.06),
            width: 1,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28), // pill-shaped, Shopify-CTA-esque
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            letterSpacing: 0.2,
          ),
        ),
      ),

      iconTheme: IconThemeData(color: textColor),

      chipTheme: ChipThemeData(
        backgroundColor: primary.withOpacity(0.10),
        labelStyle: TextStyle(
          color: primary,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
    );
  }
}
