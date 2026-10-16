import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../shared/widgets/panel.dart';
import '../../../../shared/widgets/pill.dart';
import '../../../../shared/widgets/screen_scroll.dart';
import '../../../../shared/widgets/screen_title.dart';
import '../widgets/error_heatmap.dart';
import '../widgets/pitch_lane_chart.dart';
import '../widgets/transport_controls.dart';

/// Port of `Practice` (screen titled "Session") in `src/routes/practice.tsx`.
class PracticePage extends StatelessWidget {
  const PracticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScroll(
      children: [
        const ScreenTitle(title: 'Session', sub: 'Arban Étude No. 4 · Bb Trumpet'),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: const [
              Pill(label: 'Pitch', active: true),
              SizedBox(width: 8),
              Pill(label: 'Waveform'),
              SizedBox(width: 8),
              Pill(label: 'Heatmap'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Panel(
            tone: PanelTone.lilac,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pitch lane · bars 5–8',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.foreground),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(AppRadii.full),
                      ),
                      child: const Text('±5 cents', style: TextStyle(fontSize: 12, color: AppColors.foreground)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const PitchLaneChart(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(height: 6, width: 24, decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(AppRadii.full))),
                    const SizedBox(width: 8),
                    const Text('Reference', style: TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
                    const SizedBox(width: 16),
                    Container(height: 6, width: 24, decoration: BoxDecoration(color: AppColors.sageDeep, borderRadius: BorderRadius.circular(AppRadii.full))),
                    const SizedBox(width: 8),
                    const Text('You', style: TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Panel(
            tone: PanelTone.sage,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Error heatmap · note × dimension',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.foreground),
                ),
                SizedBox(height: 12),
                ErrorHeatmap(),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: const TransportControls(),
        ),
        const Text(
          'Metronome 96 bpm · 4/4',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: AppColors.mutedForeground),
        ),
      ],
    );
  }
}
