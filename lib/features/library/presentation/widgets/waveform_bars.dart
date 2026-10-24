import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Port of the decorative waveform bars on each `Library` track card in
/// `src/routes/library.tsx`: 26 bars whose height follows
/// `20 + |sin(i * 1.3)| * 80` percent, same formula as the original.
class WaveformBars extends StatelessWidget {
  const WaveformBars({super.key, this.barCount = 26, this.height = 24});

  final int barCount;
  final double height;

  @override
  Widget build(BuildContext context) {
    AppColors.watch(context);
    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < barCount; i++) ...[
            if (i != 0) const SizedBox(width: 3),
            Container(
              width: 3,
              height: height * (0.20 + (math.sin(i * 1.3)).abs() * 0.80),
              decoration: BoxDecoration(
                color: AppColors.ink.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
