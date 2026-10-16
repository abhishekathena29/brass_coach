import 'package:flutter/material.dart';

/// Ported from `--shadow-soft` / `--shadow-float` in `src/styles.css`.
/// CSS box-shadows use a negative spread which Flutter's [BoxShadow] has no
/// equivalent for, so these are tuned by eye to read the same: soft, dark,
/// low-opacity, offset down.
class AppShadows {
  AppShadows._();

  static const List<BoxShadow> soft = [
    BoxShadow(
      color: Color(0x3D2E2A45),
      blurRadius: 24,
      offset: Offset(0, 10),
    ),
  ];

  static const List<BoxShadow> float = [
    BoxShadow(
      color: Color(0x4D26233B),
      blurRadius: 32,
      offset: Offset(0, 14),
    ),
  ];
}
