import 'package:brass_coach/app.dart';
import 'package:brass_coach/features/auth/domain/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthService extends AuthService {
  bool _signedIn = false;
  String? lastEmail;
  String? lastPassword;

  @override
  bool get isSignedIn => _signedIn;

  @override
  String? get email => _signedIn ? lastEmail : null;

  @override
  Future<void> signIn(String email, String password) async {
    lastEmail = email;
    lastPassword = password;
    _signedIn = true;
    notifyListeners();
  }

  @override
  Future<void> signOut() async {
    _signedIn = false;
    notifyListeners();
  }
}

void main() {
  testWidgets('welcome leads to a validated email sign-in', (tester) async {
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final auth = _FakeAuthService();
    await tester.pumpWidget(BrassCoachApp(authService: auth));
    await tester.pumpAndSettle();

    expect(find.text('Practice with purpose.'), findsOneWidget);
    await tester.tap(find.text('Sign in with email'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();
    expect(find.text('Enter your email address.'), findsOneWidget);
    expect(find.text('Enter your password.'), findsOneWidget);

    await tester.enterText(
      find.byType(EditableText).at(0),
      'player@example.com',
    );
    await tester.enterText(find.byType(EditableText).at(1), 'secret-password');
    await tester.ensureVisible(find.text('Sign in'));
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(auth.lastEmail, 'player@example.com');
    expect(auth.lastPassword, 'secret-password');
    expect(find.text('Adaptive goal'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('player@example.com'), findsWidgets);
    await tester.ensureVisible(find.text('Sign out'));
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    expect(find.text('Practice with purpose.'), findsOneWidget);
  });
}
