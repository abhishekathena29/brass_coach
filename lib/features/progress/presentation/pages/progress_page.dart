import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/panel.dart';
import '../../../../shared/widgets/screen_scroll.dart';
import '../../../../shared/widgets/screen_title.dart';
import '../../../../shared/widgets/stat_tile.dart';
import '../../../practice/data/practice_store.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key, required this.store});

  final PracticeStore store;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: store,
    builder: (context, _) => ScreenScroll(
      children: [
        const ScreenTitle(title: 'Progress', sub: 'Your saved practice'),
        Panel(
          tone: PanelTone.sage,
          child: Row(
            children: [
              StatTile(label: 'Sessions', value: '${store.sessions.length}'),
              const SizedBox(width: 8),
              StatTile(
                label: 'This week',
                value:
                    '${store.sessions.where((session) => session.at.isAfter(DateTime.now().subtract(const Duration(days: 7)))).length}',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text('Recent sessions', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        if (store.sessions.isEmpty)
          Panel(
            tone: PanelTone.plain,
            bordered: true,
            child: const Text(
              'No sessions saved yet. Complete a practice session to start your history.',
            ),
          )
        else
          for (final session in store.sessions) ...[
            Panel(
              tone: PanelTone.plain,
              bordered: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.piece,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.foreground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${session.focus} · ${session.at.day}/${session.at.month}/${session.at.year}',
                    style: TextStyle(color: AppColors.mutedForeground),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
      ],
    ),
  );
}
