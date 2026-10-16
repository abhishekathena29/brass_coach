import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/panel.dart';
import 'waveform_bars.dart';

class LibraryTrack {
  const LibraryTrack(this.name, this.focus, this.level, this.tone);
  final String name;
  final String focus;
  final String level;
  final PanelTone tone;
}

/// Port of each reference-recording row in `src/routes/library.tsx`.
class TrackCard extends StatelessWidget {
  const TrackCard({super.key, required this.track, this.onPlay});

  final LibraryTrack track;
  final VoidCallback? onPlay;

  @override
  Widget build(BuildContext context) {
    return Panel(
      tone: track.tone,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.foreground),
                ),
                const SizedBox(height: 4),
                Text(
                  '${track.focus} · ${track.level}',
                  style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground),
                ),
                const SizedBox(height: 12),
                const WaveformBars(),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Material(
            color: AppColors.card,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onPlay,
              child: Container(
                height: 48,
                width: 48,
                alignment: Alignment.center,
                child: const Icon(LucideIcons.play, size: 20, color: AppColors.foreground),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
