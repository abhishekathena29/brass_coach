import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../shared/widgets/meter_row.dart';
import '../../../../shared/widgets/panel.dart';
import '../../../../shared/widgets/pill.dart';
import '../../../../shared/widgets/screen_scroll.dart';
import '../../../../shared/widgets/screen_title.dart';
import '../../../../shared/widgets/stat_tile.dart';
import '../widgets/trend_bar_chart.dart';

const List<String> _highlights = [
  'Sharp above G4',
  'Late attacks after rests',
  'Airy tone at pp',
  'Strong slurs',
];

/// Port of `Progress` in `src/routes/progress.tsx`.
class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return ScreenScroll(
      children: [
        const ScreenTitle(title: 'Progress', sub: 'Last 30 days'),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Pill(label: 'Trends', active: _selectedTab == 0, onTap: () => setState(() => _selectedTab = 0)),
              const SizedBox(width: 8),
              Pill(label: 'Sessions', active: _selectedTab == 1, onTap: () => setState(() => _selectedTab = 1)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Panel(
            tone: PanelTone.sage,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    StatTile(label: 'Sessions logged', value: '24'),
                    SizedBox(width: 8),
                    StatTile(label: 'Practice hours', value: '11'),
                    SizedBox(width: 8),
                    StatTile(label: 'Pieces mastered', value: '3'),
                  ],
                ),
                SizedBox(height: 12),
                MeterRow(label: 'Overall accuracy', value: 84, tone: MeterTone.sage),
                SizedBox(height: 8),
                MeterRow(label: 'Upper-register pitch', value: 65, tone: MeterTone.sage, striped: true),
                SizedBox(height: 8),
                MeterRow(label: 'Tone consistency', value: 48, tone: MeterTone.sage),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Panel(
            tone: PanelTone.lilac,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pitch accuracy trend',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.foreground),
                ),
                const SizedBox(height: 16),
                const TrendBarChart(),
                const SizedBox(height: 12),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 14, color: AppColors.mutedForeground),
                    children: [
                      TextSpan(text: 'Upper-register pitch accuracy is up '),
                      TextSpan(
                        text: '12%',
                        style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.foreground),
                      ),
                      TextSpan(text: ' this month.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Panel(
          tone: PanelTone.plain,
          bordered: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Coach highlights',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.foreground),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tag in _highlights)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.muted,
                        borderRadius: BorderRadius.circular(AppRadii.full),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.foreground),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
