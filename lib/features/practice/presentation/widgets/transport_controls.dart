import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';

/// Port of the record/rewind/play button row in `src/routes/practice.tsx`.
class TransportControls extends StatelessWidget {
  const TransportControls({super.key, this.onRewind, this.onRecord, this.onPlay});

  final VoidCallback? onRewind;
  final VoidCallback? onRecord;
  final VoidCallback? onPlay;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _TransportButton(icon: LucideIcons.rotateCcw, size: 56, onTap: onRewind),
        const SizedBox(width: 16),
        _TransportButton(
          icon: LucideIcons.mic,
          size: 80,
          iconSize: 28,
          filled: true,
          onTap: onRecord,
        ),
        const SizedBox(width: 16),
        _TransportButton(icon: LucideIcons.play, size: 56, onTap: onPlay),
      ],
    );
  }
}

class _TransportButton extends StatelessWidget {
  const _TransportButton({
    required this.icon,
    required this.size,
    this.iconSize = 20,
    this.filled = false,
    this.onTap,
  });

  final IconData icon;
  final double size;
  final double iconSize;
  final bool filled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? AppColors.ink : AppColors.card,
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          height: size,
          width: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: filled ? AppShadows.float : AppShadows.soft,
          ),
          child: Icon(
            icon,
            size: iconSize,
            color: filled ? AppColors.primaryForeground : AppColors.foreground,
          ),
        ),
      ),
    );
  }
}
