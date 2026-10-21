import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:khuur_pitch/khuur_pitch.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../shared/widgets/screen_scroll.dart';

enum _ToolMode { tuner, metronome }

class _TunerPalette {
  const _TunerPalette._();

  static const ivory = Color(0xFFDECEBE);
  static const burgundy = Color(0xFF4E1424);
  static const rose = Color(0xFF9B616D);
  static const sage = Color(0xFF5F6B5E);
  static const mocha = Color(0xFF302C2B);
  static const softRose = Color(0xFFC8A9AA);
  static const softSage = Color(0xFFB8C0B2);
  static const paleIvory = Color(0xFFE8DDD2);
}

class TunerMetronomePage extends StatefulWidget {
  const TunerMetronomePage({super.key});

  @override
  State<TunerMetronomePage> createState() => _TunerMetronomePageState();
}

class _TunerMetronomePageState extends State<TunerMetronomePage> {
  static const _noteNames = [
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B',
  ];

  final _pitchSource = MicPitchSource(
    tracker: PitchTracker(minHz: 50, maxHz: 1600),
  );
  final _clickPlayer = AudioPlayer();
  final _bpmController = TextEditingController(text: '100');
  final List<double> _recentPitches = [];
  late final Future<void> _clickReady = _prepareClick();

  StreamSubscription<PitchFrame>? _pitchSubscription;
  Timer? _metronomeTimer;
  _ToolMode _mode = _ToolMode.tuner;
  double? _pitchHz;
  int _bpm = 100;
  int _beat = 0;
  bool _listening = false;
  bool _permissionPermanentlyDenied = false;
  bool _loadingMicrophone = false;
  String? _tunerError;

  int? get _midiNote {
    final hz = _pitchHz;
    if (hz == null) return null;
    return (69 + 12 * (math.log(hz / 440) / math.ln2)).round();
  }

  int? get _centsOff {
    final hz = _pitchHz;
    final midi = _midiNote;
    if (hz == null || midi == null) return null;
    final targetHz = 440 * math.pow(2, (midi - 69) / 12);
    return (1200 * (math.log(hz / targetHz) / math.ln2)).round();
  }

  String? get _noteLabel {
    final midi = _midiNote;
    if (midi == null) return null;
    return '${_noteNames[midi % 12]}${midi ~/ 12 - 1}';
  }

  @override
  void dispose() {
    _metronomeTimer?.cancel();
    _pitchSubscription?.cancel();
    _bpmController.dispose();
    _clickPlayer.dispose();
    super.dispose();
  }

  Future<void> _prepareClick() async {
    try {
      await _clickPlayer.setAsset('assets/audio/metronome_click.wav');
    } catch (_) {
      // Keep the tempo indicator usable if audio output is unavailable.
    }
  }

  Future<void> _playClick() async {
    await _clickReady;
    try {
      await _clickPlayer.seek(Duration.zero);
      unawaited(_clickPlayer.play());
    } catch (_) {
      // Keep the visual beat running if audio output is unavailable.
    }
  }

  Future<void> _startListening() async {
    if (_listening || _loadingMicrophone) return;
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.iOS &&
            defaultTargetPlatform != TargetPlatform.android)) {
      setState(
        () => _tunerError = 'Live tuning is available on iOS and Android.',
      );
      return;
    }
    _stopMetronome();
    setState(() {
      _loadingMicrophone = true;
      _tunerError = null;
    });
    try {
      final permission = await _pitchSource.requestPermission();
      if (!mounted) return;
      if (permission != MicPermission.granted) {
        setState(() {
          _permissionPermanentlyDenied =
              permission == MicPermission.permanentlyDenied;
          _tunerError = _permissionPermanentlyDenied
              ? 'Microphone access is off. Allow it in Settings to use the tuner.'
              : 'Microphone access is needed to hear your instrument.';
          _loadingMicrophone = false;
        });
        return;
      }
      _pitchSubscription = _pitchSource.frames().listen(
        _onPitchFrame,
        onError: _onPitchError,
      );
      setState(() {
        _listening = true;
        _loadingMicrophone = false;
        _permissionPermanentlyDenied = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _loadingMicrophone = false;
          _tunerError = 'The microphone could not be started. Try again.';
        });
      }
    }
  }

  void _onPitchFrame(PitchFrame frame) {
    final hz = frame.hz;
    if (hz == null || frame.clarity < 0.87 || frame.rmsDb < -55) {
      return;
    }
    _recentPitches.add(hz);
    if (_recentPitches.length > 5) _recentPitches.removeAt(0);
    final sorted = [..._recentPitches]..sort();
    final smoothedPitch = sorted[sorted.length ~/ 2];
    if (!mounted) return;
    setState(() => _pitchHz = smoothedPitch);
  }

  void _onPitchError(Object error) {
    if (!mounted) return;
    setState(() {
      _listening = false;
      _loadingMicrophone = false;
      _pitchSubscription = null;
      _tunerError = error is PlatformException && error.code == 'noInput'
          ? 'No microphone input was found.'
          : 'Microphone input stopped. Check your permission and try again.';
    });
  }

  Future<void> _stopListening() async {
    await _pitchSubscription?.cancel();
    _pitchSubscription = null;
    _recentPitches.clear();
    if (!mounted) return;
    setState(() {
      _listening = false;
      _pitchHz = null;
    });
  }

  Future<void> _selectMode(_ToolMode mode) async {
    if (_mode == mode) return;
    await _stopListening();
    _stopMetronome();
    if (mounted) setState(() => _mode = mode);
  }

  void _setBpm(int value) {
    final bpm = value.clamp(40, 240);
    _bpmController.text = '$bpm';
    setState(() => _bpm = bpm);
    if (_metronomeTimer != null) _startMetronome();
  }

  void _onBpmChanged(String value) {
    final bpm = int.tryParse(value);
    if (bpm == null || bpm < 40 || bpm > 240) {
      setState(() => _bpm = 0);
      _stopMetronome();
      return;
    }
    setState(() => _bpm = bpm);
    if (_metronomeTimer != null) _startMetronome();
  }

  void _startMetronome() {
    if (_bpm < 40 || _bpm > 240) return;
    _metronomeTimer?.cancel();
    _metronomeTimer = Timer.periodic(
      Duration(microseconds: (60000000 / _bpm).round()),
      (_) {
        if (!mounted) return;
        setState(() => _beat = _beat % 4 + 1);
        _playClick();
      },
    );
    setState(() => _beat = 1);
    _playClick();
  }

  void _stopMetronome() {
    _metronomeTimer?.cancel();
    _metronomeTimer = null;
    if (_beat != 0 && mounted) setState(() => _beat = 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _TunerPalette.ivory,
      body: SafeArea(
        top: false,
        child: ScreenScroll(
          children: [
            _header(context),
            const SizedBox(height: 2),
            _modeSelector(),
            const SizedBox(height: 20),
            if (_mode == _ToolMode.tuner) _tunerContent() else _metronomeContent(),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextButton.icon(
        onPressed: () => context.go('/practice'),
        style: TextButton.styleFrom(
          foregroundColor: _TunerPalette.burgundy,
          padding: EdgeInsets.zero,
        ),
        icon: const Icon(LucideIcons.arrowLeft, size: 18),
        label: const Text('Practice'),
      ),
      const SizedBox(height: 8),
      const Text(
        'Tuner & metronome',
        style: TextStyle(
          color: _TunerPalette.mocha,
          fontSize: 28,
          height: 1.1,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 5),
      const Text(
        'A clear pitch and a steady pulse.',
        style: TextStyle(color: _TunerPalette.mocha, fontSize: 14),
      ),
      const SizedBox(height: 20),
    ],
  );

  Widget _modeSelector() => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: _TunerPalette.paleIvory,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: _TunerPalette.rose.withValues(alpha: 0.24)),
    ),
    child: Row(
      children: [
        _modeButton(_ToolMode.tuner, 'Tuner', LucideIcons.audioLines),
        _modeButton(_ToolMode.metronome, 'Metronome', LucideIcons.timer),
      ],
    ),
  );

  Widget _modeButton(_ToolMode mode, String label, IconData icon) {
    final selected = _mode == mode;
    return Expanded(
      child: Semantics(
        selected: selected,
        button: true,
        child: Material(
          color: selected ? _TunerPalette.burgundy : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
          child: InkWell(
            onTap: () => _selectMode(mode),
            borderRadius: BorderRadius.circular(7),
            child: SizedBox(
              height: 44,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 17,
                    color: selected ? _TunerPalette.ivory : _TunerPalette.mocha,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: selected
                          ? _TunerPalette.ivory
                          : _TunerPalette.mocha,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tunerContent() {
    final note = _noteLabel;
    final cents = _centsOff;
    final inTune = cents != null && cents.abs() <= 4;
    final status = cents == null
        ? (_listening ? 'Play a note' : 'Ready when you are')
        : inTune
        ? 'In tune'
        : cents < 0
        ? 'Flat'
        : 'Sharp';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
          decoration: BoxDecoration(
            color: _TunerPalette.paleIvory,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _TunerPalette.rose.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Text(
                note ?? '—',
                style: const TextStyle(
                  color: _TunerPalette.burgundy,
                  fontSize: 72,
                  height: 1,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                status,
                style: TextStyle(
                  color: cents == null
                      ? _TunerPalette.sage
                      : inTune
                      ? _TunerPalette.sage
                      : _TunerPalette.rose,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _pitchHz == null ? '— Hz' : '${_pitchHz!.toStringAsFixed(1)} Hz',
                style: const TextStyle(
                  color: _TunerPalette.mocha,
                  fontSize: 13,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 54,
                child: CustomPaint(
                  painter: _TuningMeterPainter(
                    cents: cents?.toDouble(),
                    markerColor: inTune
                        ? _TunerPalette.sage
                        : _TunerPalette.burgundy,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('−50', style: _meterLabelStyle),
                  Text('0', style: _meterLabelStyle),
                  Text('+50', style: _meterLabelStyle),
                ],
              ),
              if (cents != null) ...[
                const SizedBox(height: 9),
                Text(
                  '${cents > 0 ? '+' : ''}$cents cents',
                  style: const TextStyle(
                    color: _TunerPalette.mocha,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 52,
          child: FilledButton.icon(
            onPressed: _loadingMicrophone
                ? null
                : _listening
                ? _stopListening
                : _startListening,
            style: FilledButton.styleFrom(
              backgroundColor: _TunerPalette.burgundy,
              foregroundColor: _TunerPalette.ivory,
              disabledBackgroundColor: _TunerPalette.rose.withValues(alpha: 0.5),
              disabledForegroundColor: _TunerPalette.mocha,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: Icon(
              _loadingMicrophone
                  ? LucideIcons.loaderCircle
                  : _listening
                  ? LucideIcons.micOff
                  : LucideIcons.mic,
              size: 18,
            ),
            label: Text(
              _loadingMicrophone
                  ? 'Connecting microphone…'
                  : _listening
                  ? 'Stop listening'
                  : 'Start listening',
            ),
          ),
        ),
        if (_permissionPermanentlyDenied) ...[
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _pitchSource.openAppSettings,
            style: OutlinedButton.styleFrom(
              foregroundColor: _TunerPalette.burgundy,
              side: const BorderSide(color: _TunerPalette.rose),
            ),
            icon: const Icon(LucideIcons.settings2, size: 17),
            label: const Text('Open Settings'),
          ),
        ],
        if (_tunerError != null) ...[
          const SizedBox(height: 10),
          Text(
            _tunerError!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _TunerPalette.burgundy, fontSize: 13),
          ),
        ],
      ],
    );
  }

  Widget _metronomeContent() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Container(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
        decoration: BoxDecoration(
          color: _TunerPalette.paleIvory,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _TunerPalette.rose.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            const Text(
              'TEMPO',
              style: TextStyle(
                color: _TunerPalette.sage,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                SizedBox(
                  width: 130,
                  child: TextField(
                    controller: _bpmController,
                    onChanged: _onBpmChanged,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(
                      color: _TunerPalette.burgundy,
                      fontSize: 58,
                      height: 1,
                      fontWeight: FontWeight.w700,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const Text(
                  'BPM',
                  style: TextStyle(
                    color: _TunerPalette.mocha,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final active = _beat == index + 1;
                final downbeat = index == 0;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  margin: const EdgeInsets.symmetric(horizontal: 7),
                  width: downbeat ? 13 : 10,
                  height: downbeat ? 13 : 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: active
                        ? _TunerPalette.burgundy
                        : _TunerPalette.softRose,
                  ),
                );
              }),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                _tempoNudgeButton(-1, LucideIcons.minus, 'Decrease tempo'),
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: _TunerPalette.sage,
                      inactiveTrackColor: _TunerPalette.softSage,
                      thumbColor: _TunerPalette.burgundy,
                      overlayColor: _TunerPalette.burgundy.withValues(alpha: 0.12),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: _bpm.clamp(40, 240).toDouble(),
                      min: 40,
                      max: 240,
                      onChanged: (value) => _setBpm(value.round()),
                      semanticFormatterCallback: (value) =>
                          '${value.round()} beats per minute',
                    ),
                  ),
                ),
                _tempoNudgeButton(1, LucideIcons.plus, 'Increase tempo'),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('40', style: _meterLabelStyle),
                Text('240', style: _meterLabelStyle),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 52,
        child: FilledButton.icon(
          onPressed: _bpm < 40 || _bpm > 240
              ? null
              : _metronomeTimer == null
              ? _startMetronome
              : _stopMetronome,
          style: FilledButton.styleFrom(
            backgroundColor: _TunerPalette.burgundy,
            foregroundColor: _TunerPalette.ivory,
            disabledBackgroundColor: _TunerPalette.softRose,
            disabledForegroundColor: _TunerPalette.mocha,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: Icon(
            _metronomeTimer == null ? LucideIcons.play : LucideIcons.pause,
            size: 18,
          ),
          label: Text(
            _metronomeTimer == null ? 'Start metronome' : 'Stop metronome',
          ),
        ),
      ),
    ],
  );

  Widget _tempoNudgeButton(int delta, IconData icon, String tooltip) {
    final nextBpm = _bpm + delta;
    return IconButton.filledTonal(
      tooltip: tooltip,
      onPressed: nextBpm < 40 || nextBpm > 240
          ? null
          : () => _setBpm(nextBpm),
      style: IconButton.styleFrom(
        backgroundColor: _TunerPalette.softRose,
        foregroundColor: _TunerPalette.mocha,
        disabledBackgroundColor: _TunerPalette.paleIvory,
        disabledForegroundColor: _TunerPalette.rose,
      ),
      icon: Icon(icon, size: 18),
    );
  }
}

const _meterLabelStyle = TextStyle(
  color: _TunerPalette.mocha,
  fontSize: 11,
  fontFeatures: [FontFeature.tabularFigures()],
);

class _TuningMeterPainter extends CustomPainter {
  const _TuningMeterPainter({required this.cents, required this.markerColor});

  final double? cents;
  final Color markerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final baseline = size.height - 7;
    final linePaint = Paint()
      ..color = _TunerPalette.rose.withValues(alpha: 0.55)
      ..strokeWidth = 1.2;
    final centerPaint = Paint()
      ..color = _TunerPalette.sage
      ..strokeWidth = 2;
    canvas.drawLine(Offset(0, baseline), Offset(size.width, baseline), linePaint);
    for (var index = 0; index <= 20; index++) {
      final x = size.width * index / 20;
      final isCenter = index == 10;
      final isMajor = index % 5 == 0;
      canvas.drawLine(
        Offset(x, baseline - (isMajor ? 18 : 10)),
        Offset(x, baseline + 1),
        isCenter ? centerPaint : linePaint,
      );
    }
    if (cents == null) return;
    final clamped = cents!.clamp(-50, 50);
    final x = size.width * (clamped + 50) / 100;
    final markerPaint = Paint()
      ..color = markerColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(x, 0), Offset(x, baseline - 5), markerPaint);
    canvas.drawCircle(Offset(x, 4), 4, Paint()..color = markerColor);
  }

  @override
  bool shouldRepaint(covariant _TuningMeterPainter oldDelegate) =>
      oldDelegate.cents != cents || oldDelegate.markerColor != markerColor;
}