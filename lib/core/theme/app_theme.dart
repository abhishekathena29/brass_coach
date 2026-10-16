import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Mirrors the `@theme` + `:root` tokens in `src/styles.css`, including the
/// Quicksand display/sans font pairing loaded there via Google Fonts.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: GoogleFonts.quicksand().fontFamily,
      colorScheme: const ColorScheme.light(
        surface: AppColors.background,
        onSurface: AppColors.foreground,
        primary: AppColors.primary,
        onPrimary: AppColors.primaryForeground,
        secondary: AppColors.secondary,
        onSecondary: AppColors.secondaryForeground,
        error: AppColors.destructive,
        onError: AppColors.destructiveForeground,
        outline: AppColors.border,
      ),
    );

    final textTheme = GoogleFonts.quicksandTextTheme(base.textTheme).apply(
      bodyColor: AppColors.foreground,
      displayColor: AppColors.foreground,
    );

    return base.copyWith(
      textTheme: textTheme,
      splashFactory: InkRipple.splashFactory,
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
    );
  }
}

/// Convenience: the two heading weights used across screens
/// (`ScreenTitle` = 600/semibold, panel headings = 600/semibold too).
extension AppTextStyles on TextTheme {
  TextStyle get screenTitle => GoogleFonts.quicksand(
        fontSize: 32,
        height: 1.15,
        fontWeight: FontWeight.w600,
        color: AppColors.foreground,
        letterSpacing: -0.5,
      );
}
