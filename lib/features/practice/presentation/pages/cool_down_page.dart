import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/practice_store.dart';
import '../../../../shared/widgets/panel.dart';
import '../../../../shared/widgets/screen_scroll.dart';
import '../../../../shared/widgets/screen_title.dart';

class CoolDownPage extends StatefulWidget {
  const CoolDownPage({super.key, required this.store});

  final PracticeStore store;

  @override
  State<CoolDownPage> createState() => _CoolDownPageState();
}

class _CoolDownPageState extends State<CoolDownPage> {
  static const _steps = [
    (
      'Easy long tones',
      'Play softly in a comfortable middle range for 2 minutes.',
    ),
    (
      'Gentle descending slurs',
      'Move down without pushing the air or embouchure.',
    ),
    (
      'Rest and breathe',
      'Put the instrument down and take a few relaxed breaths.',
    ),
  ];

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.store,
    builder: (context, _) => _buildContent(context),
  );

  Widget _buildContent(BuildContext context) {
    AppColors.watch(context);
    final completed = widget.store.data.coolDownCompleted.toSet();
    return ScreenScroll(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => context.go('/practice'),
            icon: const Icon(LucideIcons.arrowLeft),
            label: const Text('Practice'),
          ),
        ),
        const ScreenTitle(
          title: 'Cool-down',
          sub: 'Finish gently after your main practice',
        ),
        Panel(
          tone: PanelTone.sage,
          child: Text(
            'Take 3–5 minutes. Keep everything easy and stop if you feel strain.',
            style: TextStyle(color: AppColors.foreground),
          ),
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < _steps.length; i++) ...[
          Material(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            child: CheckboxListTile(
              value: completed.contains(i),
              onChanged: (value) {
                if (value == true) {
                  completed.add(i);
                } else {
                  completed.remove(i);
                }
                widget.store
                    .save({'coolDownCompleted': completed.toList()..sort()})
                    .catchError((Object _) {});
              },
              title: Text(_steps[i].$1),
              subtitle: Text(_steps[i].$2),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
          const SizedBox(height: 10),
        ],
        if (completed.length == _steps.length)
          Panel(
            tone: PanelTone.lilac,
            child: Text(
              'Cool-down complete. Nice work today.',
              style: TextStyle(color: AppColors.foreground),
            ),
          ),
      ],
    );
  }
}
