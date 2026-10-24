import 'dart:async';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/panel.dart';
import '../../../../shared/widgets/screen_scroll.dart';
import '../../../../shared/widgets/screen_title.dart';
import '../../../library/domain/library_tracks.dart';
import '../../data/practice_store.dart';

class MainPracticePage extends StatefulWidget {
  const MainPracticePage({super.key, this.initialSong, required this.store});

  final String? initialSong;
  final PracticeStore store;

  @override
  State<MainPracticePage> createState() => _MainPracticePageState();
}

class _MainPracticePageState extends State<MainPracticePage> {
  late LibraryTrack _song;
  bool _songSelected = false;
  String _focus = 'Practice with music';
  int _speedPercent = 100;
  Timer? _metronome;
  Timer? _saveDebounce;
  int _beat = 0;
  final _customTitle = TextEditingController();
  final _customBpm = TextEditingController();
  final _player = AudioPlayer();
  final _clickPlayer = AudioPlayer();
  late final Future<void> _clickReady;
  bool _clickAvailable = false;
  String? _loadedAudioName;
  String? _audioError;
  bool _loadingAudio = false;
  bool _savingSession = false;

  bool get _isCustom =>
      _customTitle.text.trim().isNotEmpty || _loadedAudioName != null;
  String get _pieceName {
    final title = _customTitle.text.trim();
    if (title.isNotEmpty) return title;
    if (_loadedAudioName != null) return _loadedAudioName!;
    if (_songSelected) return _song.name;
    return _focus == 'Practice with music'
        ? 'Music practice'
        : '$_focus practice';
  }

  bool get _hasTempo {
    if (!_isCustom) return _songSelected;
    final bpm = int.tryParse(_customBpm.text);
    return bpm != null && bpm >= 40 && bpm <= 240;
  }

  int get _baseBpm =>
      _isCustom ? (int.tryParse(_customBpm.text) ?? 96) : _song.bpm;
  int get _practiceBpm => (_baseBpm * _speedPercent / 100).round();

  @override
  void initState() {
    super.initState();
    final saved = widget.store.data;
    _song = libraryTracks.firstWhere(
      (track) => track.name == (widget.initialSong ?? saved.song),
      orElse: () => libraryTracks.first,
    );
    _songSelected = libraryTracks.any(
      (track) => track.name == (widget.initialSong ?? saved.song),
    );
    _focus = widget.initialSong == null ? saved.focus : 'Practice with music';
    _speedPercent = saved.speedPercent.clamp(50, 150);
    if (widget.initialSong == null) {
      _customTitle.text = saved.customTitle;
      _customBpm.text = saved.customBpm;
    }
    _clickReady = _prepareClick();
  }

  void _saveSettings() {
    widget.store
        .save({
          'song': _songSelected ? _song.name : '',
          'customTitle': _customTitle.text.trim(),
          'customBpm': _customBpm.text.trim(),
          'focus': _focus,
          'speedPercent': _speedPercent,
        })
        .catchError((Object _) {});
  }

  void _saveTextSoon() {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 450), _saveSettings);
  }

  Future<void> _logSession() async {
    setState(() => _savingSession = true);
    try {
      await widget.store.logSession(_pieceName, _focus);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Practice session saved')));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not save this session. Try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _savingSession = false);
    }
  }

  Future<void> _prepareClick() async {
    try {
      await _clickPlayer.setAsset('assets/audio/metronome_click.wav');
      _clickAvailable = true;
    } catch (_) {
      _clickAvailable = false;
    }
  }

  Future<void> _playClick() async {
    await _clickReady;
    if (!_clickAvailable) return;
    try {
      await _clickPlayer.seek(Duration.zero);
      unawaited(_clickPlayer.play().catchError((Object _) {}));
    } catch (_) {
      // The visual beat still runs if this device cannot play the click.
    }
  }

  @override
  void dispose() {
    _metronome?.cancel();
    final hasUnsavedText = _saveDebounce?.isActive ?? false;
    _saveDebounce?.cancel();
    if (hasUnsavedText) _saveSettings();
    _customTitle.dispose();
    _customBpm.dispose();
    _player.dispose();
    _clickPlayer.dispose();
    super.dispose();
  }

  Future<void> _pickAudio() async {
    setState(() {
      _loadingAudio = true;
      _audioError = null;
    });
    try {
      final file = await FilePicker.pickFile(type: FileType.audio);
      if (file == null) return;
      await _player.stop();
      if (file.path != null) {
        await _player.setFilePath(file.path!);
      } else {
        await _player.setAudioSource(AudioSource.uri(file.uri));
      }
      await _player.setSpeed(_speedPercent / 100);
      if (!mounted) return;
      setState(() {
        _loadedAudioName = file.name;
        _customTitle.text = file.name.replaceFirst(RegExp(r'\.[^.]+$'), '');
        _customBpm.clear();
      });
      _updateTempo();
      _saveSettings();
    } catch (_) {
      if (mounted) {
        setState(
          () => _audioError =
              'Could not open this audio file. Try another recording.',
        );
      }
    } finally {
      if (mounted) setState(() => _loadingAudio = false);
    }
  }

  Future<void> _toggleAudio() async {
    try {
      if (_player.playing) {
        await _player.pause();
        _stopMetronome();
      } else {
        if (_player.processingState == ProcessingState.completed) {
          await _player.seek(Duration.zero);
        }
        unawaited(
          _player.play().catchError((Object _) {
            if (mounted) {
              setState(
                () => _audioError = 'Audio playback stopped unexpectedly.',
              );
            }
          }),
        );
        if (_hasTempo) _startMetronome();
      }
    } catch (_) {
      if (mounted) {
        setState(() => _audioError = 'Audio playback could not start.');
      }
    }
  }

  void _startMetronome() {
    if (!_hasTempo) return;
    _metronome?.cancel();
    setState(() => _beat = 1);
    _playClick();
    _metronome = Timer.periodic(
      Duration(milliseconds: (60000 / _practiceBpm).round()),
      (_) {
        if (!mounted) return;
        setState(() => _beat = _beat % 4 + 1);
        _playClick();
      },
    );
  }

  void _stopMetronome() {
    _metronome?.cancel();
    _metronome = null;
    setState(() => _beat = 0);
  }

  void _updateTempo() {
    setState(() {});
    if (_metronome != null) {
      if (_hasTempo) {
        _startMetronome();
      } else {
        _stopMetronome();
      }
    }
    if (_loadedAudioName != null) {
      unawaited(
        _player.setSpeed(_speedPercent / 100).catchError((Object _) {
          if (mounted) {
            setState(() => _audioError = 'Could not change audio speed.');
          }
        }),
      );
    }
  }

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
      const ScreenTitle(title: 'Main practice', sub: 'Choose what to work on'),
      _focusCard(
        'Range',
        'Explore your comfortable low and high notes.',
        LucideIcons.moveVertical,
      ),
      const SizedBox(height: 10),
      _focusCard(
        'Fluency',
        'Build smooth scales, slurs, and articulation.',
        LucideIcons.audioLines,
      ),
      const SizedBox(height: 10),
      _focusCard(
        'Practice with music',
        'Work on a piece at a useful tempo.',
        LucideIcons.music2,
      ),
      const SizedBox(height: 16),
      if (_focus != 'Practice with music')
        Panel(
          tone: PanelTone.sage,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _focus == 'Range' ? 'Range exercise' : 'Fluency exercise',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                _focus == 'Range'
                    ? 'Start on a comfortable note. Move one note at a time, keeping your sound relaxed. Return to the middle of your range between attempts.'
                    : 'Choose an easy scale. Play it slowly and evenly, then repeat with slurs and clear tonguing.',
                style: TextStyle(color: AppColors.foreground),
              ),
            ],
          ),
        )
      else ...[
        Panel(
          tone: PanelTone.lilac,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your piece',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<LibraryTrack>(
                initialValue: _songSelected ? _song : null,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Choose from Library',
                ),
                items: [
                  for (final track in libraryTracks)
                    DropdownMenuItem(
                      value: track,
                      child: Text(track.name, overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: (track) {
                  if (track == null) return;
                  setState(() {
                    _song = track;
                    _songSelected = true;
                    _customTitle.clear();
                    _customBpm.clear();
                    _speedPercent = 100;
                    _loadedAudioName = null;
                  });
                  _player.stop();
                  _updateTempo();
                  _saveSettings();
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _customTitle,
                onChanged: (_) {
                  _updateTempo();
                  _saveTextSoon();
                },
                decoration: const InputDecoration(
                  labelText: 'Or enter your own piece',
                  hintText: 'Song title',
                ),
              ),
              if (_isCustom) ...[
                const SizedBox(height: 8),
                TextField(
                  controller: _customBpm,
                  keyboardType: TextInputType.number,
                  onChanged: (_) {
                    _updateTempo();
                    _saveTextSoon();
                  },
                  decoration: const InputDecoration(
                    labelText: 'Original tempo (bpm)',
                    helperText: 'Enter the tempo from your score',
                  ),
                ),
              ],
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _loadingAudio ? null : _pickAudio,
                icon: const Icon(LucideIcons.fileAudio),
                label: Text(
                  _loadingAudio
                      ? 'Opening audio…'
                      : 'Import your audio recording',
                ),
              ),
              if (_loadedAudioName != null) ...[
                const SizedBox(height: 8),
                Text(
                  _loadedAudioName!,
                  style: TextStyle(color: AppColors.foreground),
                ),
                StreamBuilder<bool>(
                  stream: _player.playingStream,
                  initialData: _player.playing,
                  builder: (context, snapshot) => TextButton.icon(
                    onPressed: _toggleAudio,
                    icon: Icon(
                      snapshot.data == true
                          ? LucideIcons.pause
                          : LucideIcons.play,
                    ),
                    label: Text(
                      snapshot.data == true
                          ? (_hasTempo ? 'Pause song and click' : 'Pause song')
                          : (_hasTempo ? 'Play song with click' : 'Play song'),
                    ),
                  ),
                ),
              ],
              if (_audioError != null)
                Text(
                  _audioError!,
                  style: TextStyle(color: AppColors.destructive),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Panel(
          tone: PanelTone.sage,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Practice tempo',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                _isCustom
                    ? (_hasTempo
                          ? 'Using the original tempo you entered for your piece.'
                          : 'Enter an original tempo between 40 and 240 bpm to match the click to your song.')
                    : _songSelected
                    ? 'Selected piece’s suggested tempo is ${_song.bpm} bpm.'
                    : 'Choose a piece to set its suggested tempo.',
                style: TextStyle(color: AppColors.mutedForeground),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    tooltip: 'Slow down',
                    onPressed: _speedPercent <= 50
                        ? null
                        : () {
                            _speedPercent -= 10;
                            _updateTempo();
                            _saveSettings();
                          },
                    icon: const Icon(LucideIcons.minus),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          _hasTempo ? '$_practiceBpm bpm' : '— bpm',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.foreground,
                          ),
                        ),
                        Text(
                          '$_speedPercent% of original tempo',
                          style: TextStyle(color: AppColors.mutedForeground),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Speed up',
                    onPressed: _speedPercent >= 150
                        ? null
                        : () {
                            _speedPercent += 10;
                            _updateTempo();
                            _saveSettings();
                          },
                    icon: const Icon(LucideIcons.plus),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: !_hasTempo
                      ? null
                      : (_metronome == null ? _startMetronome : _stopMetronome),
                  icon: Icon(
                    _metronome == null ? LucideIcons.play : LucideIcons.pause,
                  ),
                  label: Text(
                    _metronome == null
                        ? 'Start metronome'
                        : 'Stop metronome · beat $_beat of 4',
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                !_hasTempo
                    ? 'The recording can play at this speed. Add its original BPM to enable a matching click.'
                    : (_loadedAudioName == null
                          ? 'The click follows your practice tempo. Import a recording to play the song at this speed.'
                          : 'The click and your imported recording both use this speed.'),
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ],
      const SizedBox(height: 16),
      FilledButton.icon(
        onPressed: _savingSession ? null : _logSession,
        icon: const Icon(LucideIcons.circleCheck),
        label: Text(_savingSession ? 'Saving…' : 'Save practice session'),
      ),
    ],
  );

  Widget _focusCard(String title, String description, IconData icon) {
    final selected = _focus == title;
    return Material(
      color: selected ? AppColors.lilacSoft : AppColors.card,
      borderRadius: BorderRadius.circular(18),
      child: ListTile(
        onTap: () {
          if (title != 'Practice with music') {
            _stopMetronome();
            unawaited(_player.pause().catchError((Object _) {}));
          }
          setState(() => _focus = title);
          _saveSettings();
        },
        leading: Icon(icon, color: AppColors.foreground),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(description),
        trailing: Icon(
          selected ? LucideIcons.circleCheck : LucideIcons.chevronRight,
          color: AppColors.foreground,
        ),
      ),
    );
  }
}
