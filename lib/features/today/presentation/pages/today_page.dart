import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../shared/widgets/meter_row.dart';
import '../../../../shared/widgets/panel.dart';
import '../../../../shared/widgets/screen_scroll.dart';
import '../../../../shared/widgets/screen_title.dart';
import '../../../../shared/widgets/stat_tile.dart';
import '../widgets/warmup_list.dart';

/// Port of `Today` in `src/routes/index.tsx`.
class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScroll(
      children: [
        const ScreenTitle(title: 'Today', sub: 'Tuesday · 12 min practised'),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Panel(
            tone: PanelTone.lilac,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Adaptive goal',
                            style: TextStyle(fontSize: 14, color: AppColors.mutedForeground),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Arban Étude No. 4 — bars 5–8',
                            style: TextStyle(
                              fontSize: 20,
                              height: 1.3,
                              fontWeight: FontWeight.w600,
                              color: AppColors.foreground,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(color: AppColors.card, shape: BoxShape.circle),
                      child: const Icon(LucideIcons.target, size: 20, color: AppColors.foreground),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Upper-register intonation drifts sharp above G4. Long tones with a drone '
                  'before you run the passage.',
                  style: TextStyle(fontSize: 14, height: 1.5, color: AppColors.mutedForeground),
                ),
                const SizedBox(height: 16),
                const MeterRow(label: 'Goal progress', value: 62, striped: true),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Material(
            color: AppColors.ink,
            borderRadius: BorderRadius.circular(AppRadii.xl3),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadii.xl3),
              onTap: () => context.go('/practice'),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadii.xl3),
                  boxShadow: AppShadows.float,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Start a session',
                          style: TextStyle(fontSize: 12, color: Color(0x99FBFAF8)),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Record with metronome',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryForeground,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 48,
                      width: 48,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(color: AppColors.card, shape: BoxShape.circle),
                      child: const Icon(LucideIcons.mic, size: 20, color: AppColors.ink),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Panel(
            tone: PanelTone.sage,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Last session',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.foreground,
                      ),
                    ),
                    InkWell(
                      onTap: () => context.go('/progress'),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Details',
                            style: TextStyle(fontSize: 14, color: AppColors.mutedForeground),
                          ),
                          SizedBox(width: 4),
                          Icon(LucideIcons.arrowUpRight, size: 16, color: AppColors.mutedForeground),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    StatTile(label: 'Pitch', value: '88%'),
                    SizedBox(width: 8),
                    StatTile(label: 'Rhythm', value: '81%'),
                    SizedBox(width: 8),
                    StatTile(label: 'Tone', value: '74%'),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(AppRadii.xl2),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Coach note',
                        style: TextStyle(fontSize: 12, color: AppColors.mutedForeground),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '"Attacks land ~40 ms late after each rest. Breathe one beat earlier '
                        'and place the note on the click."',
                        style: TextStyle(fontSize: 14, height: 1.5, color: AppColors.foreground),
                      ),
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
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Warm-ups queued',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.foreground),
              ),
              SizedBox(height: 12),
              WarmupList(),
            ],
          ),
        ),
      ],
    );
  }
}
