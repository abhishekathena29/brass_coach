import '../../../shared/widgets/panel.dart';

class LibraryTrack {
  const LibraryTrack(this.name, this.focus, this.level, this.tone, this.bpm);
  final String name;
  final String focus;
  final String level;
  final PanelTone tone;
  final int bpm;
}

const libraryTracks = [
  LibraryTrack(
    'Arban Étude No. 4',
    'Articulation',
    'Intermediate',
    PanelTone.lilac,
    96,
  ),
  LibraryTrack(
    'Mahler 5 — Opening',
    'Upper register',
    'Advanced',
    PanelTone.sage,
    88,
  ),
  LibraryTrack(
    'Bb Major Scale, 2 oct.',
    'Intonation',
    'Beginner',
    PanelTone.sage,
    72,
  ),
  LibraryTrack(
    'Haydn Concerto, mvt. I',
    'Phrasing',
    'Advanced',
    PanelTone.lilac,
    120,
  ),
  LibraryTrack(
    'Long Tones — G4 to C5',
    'Tone quality',
    'Beginner',
    PanelTone.lilac,
    60,
  ),
];
