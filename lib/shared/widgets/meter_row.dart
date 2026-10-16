import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import 'stripe_fill.dart';

/// Port of `MeterRow` from `src/components/ui-kit.tsx`: a filled bar whose
/// width is the percentage value, laid over a paler track of the same hue.
/// Animates the fill width to mirror the CSS transition feel.
enum MeterTone { lilac, sage }

class MeterRow extends StatelessWidget {
  const MeterRow({
    super.key,
    required this.label,
    required this.value,
    this.striped = false,
    this.tone = MeterTone.lilac,
  });

  final String label;
  final int value;
  final bool striped;
  final MeterTone tone;

  @override
  Widget build(BuildContext context) {
    final track = tone == MeterTone.lilac
        ? AppColors.lilac.withValues(alpha: 0.4)
        : AppColors.sage.withValues(alpha: 0.4);
    final fill = tone == MeterTone.lilac ? AppColors.lilac : AppColors.sage;
    final radius = BorderRadius.circular(AppRadii.xl2);

    return ClipRRect(
      borderRadius: radius,
      child: Container(
        color: track,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final pct = value.clamp(22, 100) / 100;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              width: constraints.maxWidth * pct,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(color: fill, borderRadius: radius),
              child: Stack(
                children: [
                  if (striped) StripeFill(borderRadius: radius),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          label,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.foreground,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '$value%',
                        softWrap: false,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.foreground,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
