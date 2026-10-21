import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/library_tracks.dart';
import '../../../../shared/widgets/screen_scroll.dart';
import '../../../../shared/widgets/screen_title.dart';
import '../widgets/track_card.dart';

/// Port of `Library` in `src/routes/library.tsx`.
class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScroll(
      children: [
        const ScreenTitle(
          title: 'Library',
          sub: 'Pieces and exercises with suggested tempos',
        ),
        for (final track in libraryTracks) ...[
          if (track != libraryTracks.first) const SizedBox(height: 12),
          TrackCard(
            track: track,
            onSelect: () => context.go(
              '/practice/main?song=${Uri.encodeComponent(track.name)}',
            ),
          ),
        ],
      ],
    );
  }
}
