import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color primary = Color(0xFF632CE5);
  static const Color primaryContainer = Color(0xFF7C4DFF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFFCF6FF);
  
  static const Color secondary = Color(0xFF2B6C00);
  static const Color secondaryContainer = Color(0xFF84FB42);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF2D7100);
  
  static const Color tertiary = Color(0xFF755B00);
  static const Color tertiaryContainer = Color(0xFFD3A500);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFF503D00);

  // Surface & Background Colors
  static const Color background = Color(0xFFFAF8FF);
  static const Color onBackground = Color(0xFF10193B);
  
  static const Color surface = Color(0xFFFAF8FF);
  static const Color surfaceVariant = Color(0xFFDCE1FF);
  static const Color surfaceContainerHighest = Color(0xFFDCE1FF);
  static const Color surfaceContainerHigh = Color(0xFFE4E7FF);
  static const Color surfaceContainer = Color(0xFFEBEDFF);
  static const Color surfaceContainerLow = Color(0xFFF3F2FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  
  static const Color onSurface = Color(0xFF10193B);
  static const Color onSurfaceVariant = Color(0xFF494455);
  
  static const Color outline = Color(0xFF7A7487);
  static const Color outlineVariant = Color(0xFFCAC3D8);
  
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF93000A);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiary,
        onTertiary: onTertiary,
        tertiaryContainer: tertiaryContainer,
        onTertiaryContainer: onTertiaryContainer,
        error: error,
        onError: onError,
        errorContainer: errorContainer,
        onErrorContainer: onErrorContainer,
        surface: surface,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
      ),
      fontFamily: 'Nunito',
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 40, fontWeight: FontWeight.w800, height: 1.2, letterSpacing: -0.02),
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, height: 1.25),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, height: 1.33),
        bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.55),
        bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),
        labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, height: 1.42, letterSpacing: 0.05),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: onBackground,
        elevation: 0,
      ),
    );
  }
}
