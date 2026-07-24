import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors (Deep Violet Theme)
  static const Color primary = Color(0xFFA78BFA); // Accent: #A78BFA
  static const Color primaryContainer = Color(0xFFC4B5FD); // Accent hover: #C4B5FD
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF3B2A6B);
  
  static const Color secondary = Color(0xFF8B5CF6); // Gradient start: #8B5CF6
  static const Color secondaryContainer = Color(0xFFC084FC); // Gradient end: #C084FC
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFFFFFFFF);
  
  static const Color tertiary = Color(0xFF1E1B4B); // Deep Navy/Violet Base: #1E1B4B
  static const Color tertiaryContainer = Color(0xFF3B2A6B); // Mid Violet: #3B2A6B
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFFE9D5FF);

  // Surface & Background Colors
  static const Color background = Color(0xFF1E1B4B); 
  static const Color onBackground = Color(0xFFE9D5FF); // Body text: #E9D5FF
  
  static const Color surface = Color(0xFF2D2455); // Modal/Dialog bg: #2D2455
  static const Color surfaceVariant = Color(0xFF3B2A6B);
  static const Color surfaceContainerHighest = Color(0xFF3B2A6B);
  static const Color surfaceContainerHigh = Color(0xFF2D2455);
  static const Color surfaceContainer = Color(0xFF1E1B4B);
  static const Color surfaceContainerLow = Color(0xFF1E1B4B);
  static const Color surfaceContainerLowest = Color(0xFF0F0B29);
  
  static const Color onSurface = Color(0xFFF3F4F6); // Dialog text: #F3F4F6
  static const Color onSurfaceVariant = Color(0xFF9CA3AF); // Secondary text: #9CA3AF
  
  static const Color outline = Color(0xFFA78BFA); // Border base: rgba(167,139,250,X)
  static const Color outlineVariant = Color(0xFF6B7280); // Disabled: #6B7280
  
  static const Color error = Color(0xFFF87171); // Error: #F87171
  static const Color errorContainer = Color(0xFF7F1D1D); 
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFFFEE2E2);
  
  // Custom Status
  static const Color success = Color(0xFF34D399); // Success: #34D399
  static const Color warning = Color(0xFFFBBF24); // Warning: #FBBF24

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.transparent, // Background should be transparent for AnimatedBackground
      colorScheme: const ColorScheme.dark(
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
        displayLarge: TextStyle(fontSize: 40, fontWeight: FontWeight.w800, height: 1.2, letterSpacing: -0.02, color: Color(0xFFFFFFFF)),
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, height: 1.25, color: Color(0xFFFFFFFF)),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, height: 1.33, color: Color(0xFFFFFFFF)),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFFFFFFFF)),
        bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.55, color: Color(0xFFE9D5FF)),
        bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5, color: Color(0xFFE9D5FF)),
        bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF9CA3AF)),
        labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, height: 1.42, letterSpacing: 0.05, color: Color(0xFFA78BFA)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFFFFFFFF),
        elevation: 0,
      ),
    );
  }
}
