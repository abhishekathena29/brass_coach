import 'package:brass_coach/app.dart';
import 'package:brass_coach/features/auth/data/local_auth_service.dart';
import 'package:brass_coach/features/library/presentation/widgets/track_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

void main() {
  testWidgets('any input opens the app and sign-out returns to welcome', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final auth = LocalAuthService();
    await tester.pumpWidget(BrassCoachApp(authService: auth));
    await tester.pumpAndSettle();

    expect(find.text('Practice with purpose.'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(EditableText).at(0), 'brass player');
    await tester.ensureVisible(find.text('Continue'));
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(auth.isSignedIn, isTrue);
    expect(auth.email, 'brass player');
    expect(find.text('Today’s focus'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('brass player'), findsWidgets);
    await tester.ensureVisible(find.text('Return to welcome'));
    await tester.tap(find.text('Return to welcome'));
    await tester.pumpAndSettle();
    expect(auth.isSignedIn, isFalse);
    expect(find.text('Practice with purpose.'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Continue'));
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(auth.isSignedIn, isTrue);
    expect(find.text('Today’s focus'), findsOneWidget);
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
    await auth.signIn('', '');
    await tester.pumpWidget(BrassCoachApp(authService: auth));
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark mode'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Profile'))).brightness,
      Brightness.dark,
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
    await auth.signIn('Player', '');
    await tester.pumpWidget(BrassCoachApp(authService: auth));
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
    await auth.signIn('Player', '');
    await tester.pumpWidget(BrassCoachApp(authService: auth));
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Practice'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Tuner & metronome'));
    await tester.tap(find.text('Tuner & metronome'));
    await tester.pumpAndSettle();
    expect(find.text('Ready when you are'), findsOneWidget);
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
}
