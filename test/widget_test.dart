import 'package:brass_coach/app.dart';
import 'package:brass_coach/features/auth/data/local_auth_service.dart';
import 'package:brass_coach/features/library/presentation/widgets/track_card.dart';
import 'package:brass_coach/features/practice/data/practice_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

Future<MemoryPracticeStore> readyStore() async {
  final store = MemoryPracticeStore();
  await store.save({
    'displayName': 'Alex',
    'instrument': 'Trombone',
    'level': 'Intermediate',
    'goal': 'Improve my range',
  });
  return store;
}

void main() {
  testWidgets(
    'existing account with missing details is asked to finish setup',
    (tester) async {
      final auth = LocalAuthService();
      final store = MemoryPracticeStore();
      await store.save({'instrument': 'Trumpet'});
      await auth.signIn('player@example.com', 'password123');
      await tester.pumpWidget(
        BrassCoachApp(authService: auth, practiceStore: store),
      );
      await tester.pumpAndSettle();

      expect(find.text('Make it yours'), findsOneWidget);
      expect(
        tester
            .widget<TextFormField>(find.byType(TextFormField).at(1))
            .controller!
            .text,
        'Trumpet',
      );
      expect(find.bySemanticsLabel('Practice'), findsNothing);
    },
  );

  testWidgets('new account completes personal setup and keeps its details', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final auth = LocalAuthService();
    final store = MemoryPracticeStore();
    await tester.pumpWidget(
      BrassCoachApp(authService: auth, practiceStore: store),
    );
    await tester.pumpAndSettle();

    expect(find.text('Practice with purpose.'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('New here? Create an account'));
    await tester.tap(find.text('New here? Create an account'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(EditableText).at(0),
      'player@example.com',
    );
    await tester.enterText(find.byType(EditableText).at(1), 'password123');
    await tester.ensureVisible(find.text('Create account'));
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();

    expect(auth.isSignedIn, isTrue);
    expect(auth.email, 'player@example.com');
    expect(find.text('Make it yours'), findsOneWidget);
    expect(store.data.instrument, isEmpty);
    expect(store.data.song, isEmpty);

    await tester.ensureVisible(find.text('Save and start practicing'));
    await tester.tap(find.text('Save and start practicing'));
    await tester.pumpAndSettle();
    expect(find.text('Please fill this in.'), findsWidgets);

    await tester.enterText(find.byType(TextFormField).at(0), 'Jordan');
    await tester.enterText(find.byType(TextFormField).at(1), 'Bass trombone');
    await tester.enterText(
      find.byType(TextFormField).at(2),
      'Returning player',
    );
    await tester.enterText(
      find.byType(TextFormField).at(3),
      'Play comfortably above the staff',
    );
    await tester.ensureVisible(find.text('Save and start practicing'));
    await tester.tap(find.text('Save and start practicing'));
    await tester.pumpAndSettle();
    expect(store.data.displayName, 'Jordan');
    expect(store.data.instrument, 'Bass trombone');
    expect(store.data.level, 'Returning player');
    expect(store.data.goal, 'Play comfortably above the staff');
    expect(find.text('Choose what to practice'), findsOneWidget);
    expect(find.text('Play comfortably above the staff'), findsOneWidget);
    expect(find.text('Bass trombone · Returning player'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Profile'));
    await tester.pumpAndSettle();
    expect(find.textContaining('player@example.com'), findsWidgets);
    await tester.ensureVisible(find.text('Sign out'));
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    expect(auth.isSignedIn, isFalse);
    expect(find.text('Practice with purpose.'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(EditableText).at(0),
      'player@example.com',
    );
    await tester.enterText(find.byType(EditableText).at(1), 'password123');
    await tester.ensureVisible(find.text('Sign in'));
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();
    expect(auth.isSignedIn, isTrue);
    expect(find.text('Choose what to practice'), findsOneWidget);
    expect(find.text('Make it yours'), findsNothing);
  });

  testWidgets('dark mode and the three practice pages are usable', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final auth = LocalAuthService();
    final store = await readyStore();
    await auth.signIn('', '');
    await tester.pumpWidget(
      BrassCoachApp(authService: auth, practiceStore: store),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Profile'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Dark mode'));
    await tester.tap(find.text('Dark mode'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Profile'))).brightness,
      Brightness.dark,
    );
    expect(
      tester.widget<Scaffold>(find.byType(Scaffold).last).backgroundColor,
      const Color(0xFF302C2B),
    );

    await tester.tap(find.bySemanticsLabel('Practice'));
    await tester.pumpAndSettle();
    expect(find.text('Warm-up'), findsOneWidget);
    expect(find.text('Main practice'), findsOneWidget);
    expect(find.text('Cool-down'), findsOneWidget);

    await tester.tap(find.text('Warm-up'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'mouthpiece');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Mouthpiece buzz'));
    await tester.tap(find.text('Mouthpiece buzz'));
    await tester.pumpAndSettle();
    expect(find.text('Your warm-up'), findsOneWidget);

    await tester.ensureVisible(find.byIcon(LucideIcons.arrowLeft));
    await tester.tap(find.byIcon(LucideIcons.arrowLeft));
    await tester.pumpAndSettle();
    await tester.drag(
      find.byType(SingleChildScrollView).last,
      const Offset(0, -250),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cool-down'));
    await tester.pumpAndSettle();
    expect(find.text('Easy long tones'), findsOneWidget);
  });

  testWidgets('library piece sets metronome tempo and speed can change', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final auth = LocalAuthService();
    final store = await readyStore();
    await auth.signIn('Player', '');
    await tester.pumpWidget(
      BrassCoachApp(authService: auth, practiceStore: store),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Library'));
    await tester.pumpAndSettle();
    final secondTrack = find.byType(TrackCard).at(1);
    await tester.tap(
      find.descendant(
        of: secondTrack,
        matching: find.byIcon(LucideIcons.arrowRight),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('88 bpm'), findsOneWidget);

    await tester.ensureVisible(find.byTooltip('Slow down'));
    await tester.tap(find.byTooltip('Slow down'));
    await tester.pumpAndSettle();
    expect(find.text('79 bpm'), findsOneWidget);
    await tester.ensureVisible(find.text('Start metronome'));
    await tester.tap(find.text('Start metronome'));
    await tester.pump();
    expect(find.textContaining('Stop metronome'), findsOneWidget);
    await tester.tap(find.textContaining('Stop metronome'));
    await tester.pump();

    await tester.ensureVisible(find.byType(TextField).first);
    await tester.enterText(find.byType(TextField).first, 'My song');
    await tester.pumpAndSettle();
    expect(find.text('— bpm'), findsOneWidget);
    final startButton = tester.widget<FilledButton>(
      find.ancestor(
        of: find.text('Start metronome'),
        matching: find.byType(FilledButton),
      ),
    );
    expect(startButton.onPressed, isNull);

    await tester.enterText(find.byType(TextField).last, '120');
    await tester.pumpAndSettle();
    expect(find.text('108 bpm'), findsOneWidget);
  });

  testWidgets('tuner and metronome share a page with editable tempo', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final auth = LocalAuthService();
    final store = await readyStore();
    await auth.signIn('Player', '');
    await tester.pumpWidget(
      BrassCoachApp(authService: auth, practiceStore: store),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Practice'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Tuner & metronome'));
    await tester.tap(find.text('Tuner & metronome'));
    await tester.pumpAndSettle();
    expect(find.text('Ready when you are'), findsOneWidget);
    expect(find.text('PLAYED NOTE'), findsOneWidget);
    expect(find.text('FLAT'), findsOneWidget);
    expect(find.text('IN TUNE'), findsOneWidget);
    expect(find.text('SHARP'), findsOneWidget);
    expect(find.textContaining('Hz'), findsNothing);
    expect(find.textContaining('cents'), findsNothing);
    expect(find.text('Start listening'), findsOneWidget);

    await tester.tap(find.text('Metronome'));
    await tester.pumpAndSettle();
    expect(find.text('TEMPO'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '128');
    await tester.pumpAndSettle();
    expect(find.text('128'), findsOneWidget);
    await tester.ensureVisible(find.text('Start metronome'));
    await tester.tap(find.text('Start metronome'));
    await tester.pump();
    expect(find.text('Stop metronome'), findsOneWidget);
    await tester.tap(find.text('Stop metronome'));
    await tester.pump();

    await tester.tap(find.text('Tuner'));
    await tester.pumpAndSettle();
    expect(find.text('Start listening'), findsOneWidget);
  });

  testWidgets('practice choices and sessions appear after navigation', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final auth = LocalAuthService();
    final store = await readyStore();
    await auth.signIn('player@example.com', 'password123');
    await tester.pumpWidget(
      BrassCoachApp(authService: auth, practiceStore: store),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Practice'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Warm-up'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Long tones').first);
    await tester.pumpAndSettle();
    expect(store.data.selectedWarmup, 'Long tones');

    await tester.tap(find.bySemanticsLabel('Today'));
    await tester.pumpAndSettle();
    expect(find.text('Long tones'), findsOneWidget);

    await tester.tap(find.text('Start main practice'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Save practice session'));
    await tester.tap(find.text('Save practice session'));
    await tester.pumpAndSettle();
    expect(store.sessions.length, 1);

    await tester.tap(find.bySemanticsLabel('Progress'));
    await tester.pumpAndSettle();
    expect(find.text('Recent sessions'), findsOneWidget);
    expect(find.text('Music practice'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit your details'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(1), 'Trumpet');
    await tester.ensureVisible(find.text('Save my details'));
    await tester.tap(find.text('Save my details'));
    await tester.pumpAndSettle();
    expect(store.data.instrument, 'Trumpet');
  });

  testWidgets('dark mode keeps the current page and practice state', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final auth = LocalAuthService();
    final store = await readyStore();
    await auth.signIn('player@example.com', 'password123');
    await tester.pumpWidget(
      BrassCoachApp(authService: auth, practiceStore: store),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Practice'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Tuner & metronome'));
    await tester.tap(find.text('Tuner & metronome'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Metronome'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '999');
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Profile'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Dark mode'));
    await tester.tap(find.text('Dark mode'));
    await tester.pumpAndSettle();
    expect(find.text('Profile'), findsOneWidget);
    expect(store.data.darkMode, isTrue);
    expect(
      Theme.of(tester.element(find.text('Profile'))).brightness,
      Brightness.dark,
    );
    expect(
      tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
      isTrue,
    );

    await tester.tap(find.bySemanticsLabel('Practice'));
    await tester.pumpAndSettle();
    expect(find.text('999'), findsOneWidget);
    expect(find.text('TEMPO'), findsOneWidget);
    expect(
      tester.widget<Scaffold>(find.byType(Scaffold).last).backgroundColor,
      const Color(0xFF302C2B),
    );

    await tester.tap(find.bySemanticsLabel('Library'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.text('Arban Étude No. 4')).style?.color,
      const Color(0xFFDECEBE),
    );

    await tester.tap(find.bySemanticsLabel('Profile'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Dark mode'));
    await tester.tap(find.text('Dark mode'));
    await tester.pumpAndSettle();
    expect(store.data.darkMode, isFalse);
    expect(
      Theme.of(tester.element(find.text('Profile'))).brightness,
      Brightness.light,
    );
    expect(
      tester.widget<Scaffold>(find.byType(Scaffold).last).backgroundColor,
      const Color(0xFFDECEBE),
    );
  });
}
