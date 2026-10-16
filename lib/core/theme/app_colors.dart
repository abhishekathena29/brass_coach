import 'package:flutter/material.dart';

/// Design tokens ported 1:1 from `src/styles.css` (oklch → sRGB hex).
/// Keep this file as the single source of truth for color.
class AppColors {
  AppColors._();

  static const background = Color(0xFFF7F6F2);
  static const foreground = Color(0xFF191A1F);

  static const card = Color(0xFFFFFFFF);
  static const cardForeground = Color(0xFF191A1F);

  static const primary = Color(0xFF191A1E);
  static const primaryForeground = Color(0xFFFBFAF8);

  static const secondary = Color(0xFFCBD3F3);
  static const secondaryForeground = Color(0xFF1C1F29);

  static const muted = Color(0xFFEEEDE8);
  static const mutedForeground = Color(0xFF696B74);

  static const accent = Color(0xFFD3E5C3);
  static const accentForeground = Color(0xFF1F2717);

  static const destructive = Color(0xFFDB4241);
  static const destructiveForeground = Color(0xFFFBFAF8);

  static const border = Color(0xFFDCDEE3);
  static const ring = Color(0xFF99A2CB);

  // Brand palette
  static const lilac = Color(0xFFC6CFF6);
  static const lilacSoft = Color(0xFFE4E9FD);
  static const lilacDeep = Color(0xFF9199D6);

  static const sage = Color(0xFFD5E5BE);
  static const sageSoft = Color(0xFFECF4E0);
  static const sageDeep = Color(0xFF84A469);

  static const butter = Color(0xFFF6E8B3);
  static const clay = Color(0xFFF0C2AE);
  static const ink = Color(0xFF131417);
  static const surface = Color(0xFFFBFAF7);
}
