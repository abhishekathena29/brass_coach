import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/panel.dart';
import '../../../../shared/widgets/screen_scroll.dart';
import '../../../../shared/widgets/screen_title.dart';

class CoolDownPage extends StatefulWidget {
  const CoolDownPage({super.key});

  @override
  State<CoolDownPage> createState() => _CoolDownPageState();
}

class _CoolDownPageState extends State<CoolDownPage> {
  final Set<int> _completed = {};
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
  Widget build(BuildContext context) => ScreenScroll(
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
            value: _completed.contains(i),
            onChanged: (value) => setState(() {
              if (value == true) {
                _completed.add(i);
              } else {
                _completed.remove(i);
              }
            }),
            title: Text(_steps[i].$1),
            subtitle: Text(_steps[i].$2),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
        const SizedBox(height: 10),
      ],
      if (_completed.length == _steps.length)
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
