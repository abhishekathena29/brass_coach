import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/library_tracks.dart';
import '../../../../shared/widgets/panel.dart';
import 'waveform_bars.dart';

/// Port of each reference-recording row in `src/routes/library.tsx`.
class TrackCard extends StatelessWidget {
  const TrackCard({super.key, required this.track, this.onSelect});

  final LibraryTrack track;
  final VoidCallback? onSelect;

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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.foreground,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${track.focus} · ${track.level} · ${track.bpm} bpm',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.mutedForeground,
                  ),
                ),
                SizedBox(height: 12),
                WaveformBars(),
              ],
            ),
          ),
          SizedBox(width: 12),
          Material(
            color: AppColors.card,
            shape: CircleBorder(),
            child: IconButton(
              tooltip: 'Practice ${track.name}',
              onPressed: onSelect,
              icon: Icon(
                LucideIcons.arrowRight,
                size: 20,
                color: AppColors.foreground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
