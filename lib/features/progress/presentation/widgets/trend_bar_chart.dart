import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

const List<int> _bars = [42, 55, 48, 63, 70, 66, 78, 84];

/// Port of the weekly "Pitch accuracy trend" bar chart in
/// `src/routes/progress.tsx`: bars are card-colored except the last
/// (this week), which is ink-colored to stand out.
class TrendBarChart extends StatelessWidget {
  const TrendBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 128,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < _bars.length; i++) ...[
            if (i != 0) SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                    height: 128 * (_bars[i] / 100),
                    decoration: BoxDecoration(
                      color: i == _bars.length - 1 ? AppColors.ink : AppColors.card,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(6),
                        bottomRight: Radius.circular(6),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('W${i + 1}', style: TextStyle(fontSize: 10, color: AppColors.mutedForeground)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
