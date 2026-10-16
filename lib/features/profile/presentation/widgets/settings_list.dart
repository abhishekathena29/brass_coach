import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';

class SettingItem {
  const SettingItem(this.label, this.value);
  final String label;
  final String value;
}

const List<SettingItem> kSettings = [
  SettingItem('Instrument', 'Bb Trumpet'),
  SettingItem('Daily goal', '20 min'),
  SettingItem('Metronome', '96 bpm · 4/4'),
  SettingItem('Mic calibration', 'Calibrated'),
  SettingItem('Feedback detail', 'Detailed'),
];

/// Port of the settings list in `src/routes/profile.tsx`.
class SettingsList extends StatelessWidget {
  const SettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < kSettings.length; i++)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: i == kSettings.length - 1
                  ? null
                  : const Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  kSettings[i].label,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.foreground),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      kSettings[i].value,
                      style: const TextStyle(fontSize: 14, color: AppColors.mutedForeground),
                    ),
                    const SizedBox(width: 8),
                    const Icon(LucideIcons.chevronRight, size: 16, color: AppColors.mutedForeground),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
