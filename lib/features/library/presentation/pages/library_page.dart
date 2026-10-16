import 'package:flutter/material.dart';

import '../../../../shared/widgets/panel.dart';
import '../../../../shared/widgets/pill.dart';
import '../../../../shared/widgets/screen_scroll.dart';
import '../../../../shared/widgets/screen_title.dart';
import '../widgets/track_card.dart';

const List<String> _instruments = ['Trumpet', 'Trombone', 'Horn', 'Tuba'];

const List<LibraryTrack> _tracks = [
  LibraryTrack('Arban Étude No. 4', 'Articulation', 'Intermediate', PanelTone.lilac),
  LibraryTrack('Mahler 5 — Opening', 'Upper register', 'Advanced', PanelTone.sage),
  LibraryTrack('Bb Major Scale, 2 oct.', 'Intonation', 'Beginner', PanelTone.sage),
  LibraryTrack('Haydn Concerto, mvt. I', 'Phrasing', 'Advanced', PanelTone.lilac),
  LibraryTrack('Long Tones — G4 to C5', 'Tone quality', 'Beginner', PanelTone.lilac),
];

/// Port of `Library` in `src/routes/library.tsx`.
class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  int _selectedInstrument = 0;

  @override
  Widget build(BuildContext context) {
    return ScreenScroll(
      children: [
        const ScreenTitle(title: 'Library', sub: 'Pre-analysed professional takes'),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _instruments.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) => Pill(
                label: _instruments[i],
                active: i == _selectedInstrument,
                onTap: () => setState(() => _selectedInstrument = i),
              ),
            ),
          ),
        ),
        for (final track in _tracks) ...[
          if (track != _tracks.first) const SizedBox(height: 12),
          TrackCard(track: track),
        ],
      ],
    );
  }
}
