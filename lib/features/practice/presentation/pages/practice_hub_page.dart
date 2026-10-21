import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/panel.dart';
import '../../../../shared/widgets/screen_scroll.dart';
import '../../../../shared/widgets/screen_title.dart';

class PracticeHubPage extends StatelessWidget {
  const PracticeHubPage({super.key});

  @override
  Widget build(BuildContext context) => ScreenScroll(
    children: [
      const ScreenTitle(
        title: 'Practice',
        sub: 'Choose a part of your session',
      ),
      _PhaseCard(
        title: 'Warm-up',
        description: 'Find a short exercise to get ready to play.',
        icon: LucideIcons.sun,
        tone: PanelTone.sage,
        onTap: () => context.go('/practice/warm-up'),
      ),
      const SizedBox(height: 12),
      _PhaseCard(
        title: 'Main practice',
        description: 'Work on range, fluency, or a piece of music.',
        icon: LucideIcons.music2,
        tone: PanelTone.lilac,
        onTap: () => context.go('/practice/main'),
      ),
      const SizedBox(height: 12),
      _PhaseCard(
        title: 'Cool-down',
        description: 'Finish with relaxed, gentle playing.',
        icon: LucideIcons.moon,
        tone: PanelTone.plain,
        onTap: () => context.go('/practice/cool-down'),
      ),
      const SizedBox(height: 12),
      _PhaseCard(
        title: 'Tuner & metronome',
        description: 'Check your pitch or set a steady tempo.',
        icon: LucideIcons.audioLines,
        tone: PanelTone.sage,
        onTap: () => context.go('/practice/tuner'),
      ),
    ],
  );
}

class _PhaseCard extends StatelessWidget {
  const _PhaseCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.tone,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final PanelTone tone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Panel(
        tone: tone,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: AppColors.foreground, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: AppColors.foreground,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(color: AppColors.mutedForeground),
                    ),
                  ],
                ),
              ),
              Icon(LucideIcons.chevronRight, color: AppColors.foreground),
            ],
          ),
        ),
      ),
    ),
  );
}
