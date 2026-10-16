import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';

class WarmupItem {
  const WarmupItem(this.name, this.duration);
  final String name;
  final String duration;
}

const List<WarmupItem> kWarmups = [
  WarmupItem('Long tones · G4–C5', '4 min'),
  WarmupItem('Lip slurs, 1st–3rd partial', '3 min'),
  WarmupItem('Chromatic scale, mf', '5 min'),
];

/// Port of the "Warm-ups queued" list on the Today screen
/// (`src/routes/index.tsx`).
class WarmupList extends StatelessWidget {
  const WarmupList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in kWarmups) ...[
          if (item != kWarmups.first) const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.muted,
              borderRadius: BorderRadius.circular(AppRadii.xl2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    item.name,
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
                  item.duration,
                  style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
