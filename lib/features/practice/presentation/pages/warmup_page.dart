import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/practice_store.dart';
import '../../../../shared/widgets/panel.dart';
import '../../../../shared/widgets/screen_scroll.dart';
import '../../../../shared/widgets/screen_title.dart';

class WarmupExercise {
  const WarmupExercise(this.name, this.detail, this.minutes);
  final String name;
  final String detail;
  final int minutes;
}

const warmupExercises = [
  WarmupExercise('Long tones', 'Steady air and a centered sound', 4),
  WarmupExercise('Gentle lip slurs', 'Move smoothly between nearby notes', 3),
  WarmupExercise('Easy scales', 'Start slowly in a comfortable range', 5),
  WarmupExercise('Breathing patterns', 'Relaxed inhale and even exhale', 3),
  WarmupExercise('Mouthpiece buzz', 'Light, steady pitch', 2),
  WarmupExercise('Chromatic warm-up', 'Small steps with even fingers', 5),
  WarmupExercise('Articulation starts', 'Soft, clear note beginnings', 4),
];

class WarmupPage extends StatefulWidget {
  const WarmupPage({super.key, required this.store});

  final PracticeStore store;

  @override
  State<WarmupPage> createState() => _WarmupPageState();
}

class _WarmupPageState extends State<WarmupPage> {
  String _query = '';

  void _choose(WarmupExercise exercise) {
    widget.store
        .save({'selectedWarmup': exercise.name})
        .catchError((Object _) {});
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.store,
      builder: (context, _) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final selectedName = widget.store.data.selectedWarmup;
    final selected = warmupExercises
        .where((item) => item.name == selectedName)
        .firstOrNull;
    final matches = warmupExercises
        .where(
          (exercise) =>
              exercise.name.toLowerCase().contains(_query.toLowerCase()) ||
              exercise.detail.toLowerCase().contains(_query.toLowerCase()),
        )
        .toList();
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
          title: 'Warm-up',
          sub: 'Choose an exercise that feels right today',
        ),
        Text(
          'Suggested warm-ups',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        for (final exercise in warmupExercises.take(3)) ...[
          _ExerciseTile(
            exercise: exercise,
            selected: selected == exercise,
            onTap: () => _choose(exercise),
          ),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 20),
        Text('Find a warm-up', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        TextField(
          onChanged: (value) => setState(() => _query = value.trim()),
          decoration: InputDecoration(
            hintText: 'Search by exercise or focus',
            prefixIcon: const Icon(LucideIcons.search),
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        const SizedBox(height: 12),
        if (matches.isEmpty)
          const Text('No warm-ups found. Try another search.')
        else
          for (final exercise in matches) ...[
            _ExerciseTile(
              exercise: exercise,
              selected: selected == exercise,
              onTap: () => _choose(exercise),
            ),
            const SizedBox(height: 8),
          ],
        if (selected != null) ...[
          const SizedBox(height: 12),
          Panel(
            tone: PanelTone.sage,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your warm-up',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '${selected.name} · ${selected.minutes} min',
                  style: TextStyle(color: AppColors.foreground),
                ),
                const SizedBox(height: 8),
                Text(
                  selected.detail,
                  style: TextStyle(color: AppColors.mutedForeground),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  const _ExerciseTile({
    required this.exercise,
    required this.selected,
    required this.onTap,
  });
  final WarmupExercise exercise;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: selected ? AppColors.lilacSoft : AppColors.card,
    borderRadius: BorderRadius.circular(16),
    child: ListTile(
      onTap: onTap,
      title: Text(exercise.name),
      subtitle: Text(exercise.detail),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            selected ? LucideIcons.circleCheck : LucideIcons.circlePlus,
            color: AppColors.foreground,
            size: 20,
          ),
          Text(
            '${exercise.minutes} min',
            style: TextStyle(fontSize: 11, color: AppColors.mutedForeground),
          ),
        ],
      ),
    ),
  );
}
