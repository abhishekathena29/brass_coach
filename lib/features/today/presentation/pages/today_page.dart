import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/panel.dart';
import '../../../../shared/widgets/screen_scroll.dart';
import '../../../../shared/widgets/screen_title.dart';
import '../../../practice/data/practice_store.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key, required this.store});

  final PracticeStore store;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: store,
    builder: (context, _) {
      final last = store.sessions.firstOrNull;
      return ScreenScroll(
        children: [
          ScreenTitle(
            title: 'Today',
            sub: 'Ready when you are, ${store.data.displayName}',
          ),
          Panel(
            tone: PanelTone.sage,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your goal',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(store.data.goal),
                const SizedBox(height: 4),
                Text(
                  '${store.data.instrument} · ${store.data.level}',
                  style: TextStyle(color: AppColors.mutedForeground),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Panel(
            tone: PanelTone.lilac,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  store.data.song.isEmpty && store.data.customTitle.isEmpty
                      ? 'Choose what to practice'
                      : 'Continue practicing',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  store.data.customTitle.isNotEmpty
                      ? store.data.customTitle
                      : store.data.song.isNotEmpty
                      ? store.data.song
                      : 'Choose a piece or add your own',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.foreground,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  store.data.focus,
                  style: TextStyle(color: AppColors.mutedForeground),
                ),
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: () => context.go('/practice/main'),
                  icon: const Icon(LucideIcons.play),
                  label: const Text('Start main practice'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Panel(
            tone: PanelTone.sage,
            child: Material(
              color: Colors.transparent,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Warm-up'),
                subtitle: Text(
                  store.data.selectedWarmup ?? 'Choose a warm-up for today',
                ),
                trailing: const Icon(LucideIcons.arrowRight),
                onTap: () => context.go('/practice/warm-up'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Panel(
            tone: PanelTone.plain,
            bordered: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Last saved session',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  last == null
                      ? 'No sessions saved yet'
                      : '${last.piece} · ${last.focus}',
                ),
                const SizedBox(height: 6),
                Text(
                  last == null
                      ? 'Save a session after you practice to see it here.'
                      : '${last.at.day}/${last.at.month}/${last.at.year}',
                  style: TextStyle(color: AppColors.mutedForeground),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
