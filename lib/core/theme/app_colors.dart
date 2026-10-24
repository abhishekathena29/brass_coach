import 'package:flutter/material.dart';

/// Shared colors for light and dark appearance.
class AppColors {
  AppColors._();

  static bool isDark = false;

  /// Registers a theme dependency for widgets that use these shared colors.
  static void watch(BuildContext context) {
    Theme.of(context);
  }

  static Color get background =>
      isDark ? const Color(0xFF302C2B) : const Color(0xFFDECEBE);
  static Color get foreground =>
      isDark ? const Color(0xFFDECEBE) : const Color(0xFF302C2B);
  static Color get card =>
      isDark ? const Color(0xFF403A37) : const Color(0xFFE8DDD2);
  static Color get cardForeground => foreground;
  static Color get primary => isDark ? const Color(0xFFC78D97) : ink;
  static Color get actionForeground =>
      isDark ? const Color(0xFF302C2B) : const Color(0xFFDECEBE);
  static Color get primaryForeground => const Color(0xFFDECEBE);
  static Color get secondary =>
      isDark ? const Color(0xFF9B616D) : const Color(0xFFC8A9AA);
  static Color get secondaryForeground =>
      isDark ? const Color(0xFFDECEBE) : const Color(0xFF302C2B);
  static Color get muted =>
      isDark ? const Color(0xFF443D3A) : const Color(0xFFD4C4B8);
  static Color get mutedForeground =>
      isDark ? const Color(0xFFC7B8AC) : const Color(0xFF655651);
  static Color get accent => sage;
  static Color get accentForeground =>
      isDark ? const Color(0xFF302C2B) : const Color(0xFFDECEBE);
  static Color get destructive =>
      isDark ? const Color(0xFFC78D97) : const Color(0xFF4E1424);
  static Color get destructiveForeground =>
      isDark ? const Color(0xFF302C2B) : const Color(0xFFDECEBE);
  static Color get border =>
      isDark ? const Color(0xFF625752) : const Color(0xFFC4B3A7);
  static Color get ring => isDark ? const Color(0xFFC8A9AA) : sage;
  static Color get lilac =>
      isDark ? const Color(0xFFC8A9AA) : const Color(0xFF9B616D);
  static Color get lilacSoft =>
      isDark ? const Color(0xFF4A363A) : const Color(0xFFC8A9AA);
  static Color get lilacDeep =>
      isDark ? const Color(0xFFDECEBE) : const Color(0xFF4E1424);
  static Color get sage =>
      isDark ? const Color(0xFF8A9A86) : const Color(0xFF5F6B5E);
  static Color get sageSoft =>
      isDark ? const Color(0xFF394139) : const Color(0xFFB8C0B2);
  static Color get sageDeep =>
      isDark ? const Color(0xFFBDCEB9) : const Color(0xFF435044);
  static Color get butter =>
      isDark ? const Color(0xFFC8A9AA) : const Color(0xFFC8A9AA);
  static Color get clay =>
      isDark ? const Color(0xFFBA857A) : const Color(0xFF9B616D);
  static Color get ink => const Color(0xFF4E1424);
  static Color get surface =>
      isDark ? const Color(0xFF302C2B) : const Color(0xFFF0E8DF);
}
