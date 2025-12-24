import 'package:flutter/material.dart';

// Theme tokens for colors and typography.
class AppTheme {
  // Build the light theme configuration.
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        error: AppColors.error,
        onError: Colors.white,
        background: AppColors.backgroundLight,
        onBackground: AppColors.onBackgroundLight,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.onSurfaceLight,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: _textTheme(Brightness.light),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.onSurfaceLight,
      ),
      dividerColor: AppColors.dividerLight,
    );
  }

  // Build the dark theme configuration.
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        error: AppColors.error,
        onError: Colors.white,
        background: AppColors.backgroundDark,
        onBackground: AppColors.onBackgroundDark,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.onSurfaceDark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: _textTheme(Brightness.dark),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.onSurfaceDark,
      ),
      dividerColor: AppColors.dividerDark,
    );
  }

  // Build the custom theme configuration.
  static ThemeData custom() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppCustomColors.primary,
        onPrimary: AppCustomColors.onPrimary,
        secondary: AppCustomColors.secondary,
        onSecondary: AppCustomColors.onSecondary,
        error: AppCustomColors.error,
        onError: AppCustomColors.onError,
        background: AppCustomColors.background,
        onBackground: AppCustomColors.onBackground,
        surface: AppCustomColors.surface,
        onSurface: AppCustomColors.onSurface,
      ),
      scaffoldBackgroundColor: AppCustomColors.background,
      textTheme: _customTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppCustomColors.surface,
        foregroundColor: AppCustomColors.onSurface,
      ),
      dividerColor: AppCustomColors.divider,
    );
  }

  // Build a text theme based on the target brightness.
  static TextTheme _textTheme(Brightness brightness) {
    final Color baseColor = brightness == Brightness.dark
        ? AppColors.onBackgroundDark
        : AppColors.onBackgroundLight;
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: AppTextSizes.displayLarge,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      displayMedium: TextStyle(
        fontSize: AppTextSizes.displayMedium,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      titleLarge: TextStyle(
        fontSize: AppTextSizes.titleLarge,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      titleMedium: TextStyle(
        fontSize: AppTextSizes.titleMedium,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      bodyLarge: TextStyle(
        fontSize: AppTextSizes.bodyLarge,
        fontWeight: FontWeight.w400,
        color: baseColor,
      ),
      bodyMedium: TextStyle(
        fontSize: AppTextSizes.bodyMedium,
        fontWeight: FontWeight.w400,
        color: baseColor,
      ),
      labelLarge: TextStyle(
        fontSize: AppTextSizes.labelLarge,
        fontWeight: FontWeight.w500,
        color: baseColor,
      ),
    );
  }

  // Build a text theme for the custom palette.
  static TextTheme _customTextTheme() {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: AppTextSizes.displayLarge,
        fontWeight: FontWeight.w700,
        color: AppCustomColors.onBackground,
      ),
      displayMedium: TextStyle(
        fontSize: AppTextSizes.displayMedium,
        fontWeight: FontWeight.w700,
        color: AppCustomColors.onBackground,
      ),
      titleLarge: TextStyle(
        fontSize: AppTextSizes.titleLarge,
        fontWeight: FontWeight.w600,
        color: AppCustomColors.onBackground,
      ),
      titleMedium: TextStyle(
        fontSize: AppTextSizes.titleMedium,
        fontWeight: FontWeight.w600,
        color: AppCustomColors.onBackground,
      ),
      bodyLarge: TextStyle(
        fontSize: AppTextSizes.bodyLarge,
        fontWeight: FontWeight.w400,
        color: AppCustomColors.onBackground,
      ),
      bodyMedium: TextStyle(
        fontSize: AppTextSizes.bodyMedium,
        fontWeight: FontWeight.w400,
        color: AppCustomColors.onBackground,
      ),
      labelLarge: TextStyle(
        fontSize: AppTextSizes.labelLarge,
        fontWeight: FontWeight.w500,
        color: AppCustomColors.onBackground,
      ),
    );
  }
}

// Color tokens shared by light and dark themes.
class AppColors {
  static const Color primary = Color(0xFF1B5E7A);
  static const Color secondary = Color(0xFFE07A5F);
  static const Color error = Color(0xFFB00020);

  static const Color backgroundLight = Color(0xFFF7F5F2);
  static const Color onBackgroundLight = Color(0xFF1C1B1F);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color onSurfaceLight = Color(0xFF1C1B1F);
  static const Color dividerLight = Color(0xFFE0DDD8);

  static const Color backgroundDark = Color(0xFF121417);
  static const Color onBackgroundDark = Color(0xFFF1F1F1);
  static const Color surfaceDark = Color(0xFF1B1F24);
  static const Color onSurfaceDark = Color(0xFFEAEAEA);
  static const Color dividerDark = Color(0xFF2B3036);
}

// Typography scale tokens.
class AppTextSizes {
  static const double displayLarge = 32.0;
  static const double displayMedium = 24.0;
  static const double titleLarge = 20.0;
  static const double titleMedium = 16.0;
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double labelLarge = 12.0;
}

// Palette custom "loufoque" pour exemple.
class AppCustomColors {
  static const Color primary = Color(0xFF00E5FF);
  static const Color onPrimary = Color(0xFF002B36);
  static const Color secondary = Color(0xFFFF3D8D);
  static const Color onSecondary = Color(0xFF2B001A);
  static const Color error = Color(0xFFFF6B35);
  static const Color onError = Color(0xFF2B1600);

  static const Color background = Color(0xFFFFF7D1);
  static const Color onBackground = Color(0xFF2C1B00);
  static const Color surface = Color(0xFFE0F7FA);
  static const Color onSurface = Color(0xFF002B36);
  static const Color divider = Color(0xFFFFD54F);
}
