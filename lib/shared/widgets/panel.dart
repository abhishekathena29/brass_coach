import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';

/// Port of `Panel` from `src/components/ui-kit.tsx`.
enum PanelTone { lilac, sage, plain }

class Panel extends StatelessWidget {
  const Panel({
    super.key,
    required this.child,
    this.tone = PanelTone.lilac,
    this.bordered = false,
    this.padding = const EdgeInsets.all(16),
    this.margin,
  });

  final Widget child;
  final PanelTone tone;
  final bool bordered;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  Color get _fill => switch (tone) {
        PanelTone.lilac => AppColors.lilacSoft,
        PanelTone.sage => AppColors.sageSoft,
        PanelTone.plain => AppColors.card,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: _fill,
        borderRadius: BorderRadius.circular(AppRadii.xl3),
        border: bordered ? Border.all(color: AppColors.border) : null,
      ),
      child: child,
    );
  }
}
