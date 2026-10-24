import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../domain/auth_service.dart';

class FirebaseAuthService extends AuthService {
  FirebaseAuthService(this._auth) {
    _subscription = _auth.authStateChanges().listen((_) => notifyListeners());
  }

  final FirebaseAuth _auth;
  late final StreamSubscription<User?> _subscription;

  @override
  bool get isSignedIn => _auth.currentUser != null;

  @override
  String? get email => _auth.currentUser?.email;

  @override
  String? get uid => _auth.currentUser?.uid;

  @override
  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    notifyListeners();
  }

  @override
  Future<void> signUp(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    notifyListeners();
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
