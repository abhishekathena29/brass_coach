import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/auth_service.dart';

class SupabaseAuthService extends AuthService {
  SupabaseAuthService(this._client) {
    _subscription = _client.auth.onAuthStateChange.listen(
      (_) => notifyListeners(),
    );
  }

  final SupabaseClient _client;
  late final StreamSubscription<AuthState> _subscription;

  @override
  bool get isSignedIn => _client.auth.currentSession != null;

  @override
  String? get email => _client.auth.currentUser?.email;

  @override
  Future<void> signIn(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.session == null) {
        throw const AuthFailure(
          'Sign in could not be completed. Please try again.',
        );
      }
      notifyListeners();
    } on AuthException catch (error) {
      throw AuthFailure(error.message);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
      notifyListeners();
    } on AuthException catch (error) {
      throw AuthFailure(error.message);
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class UnconfiguredAuthService extends AuthService {
  @override
  bool get isSignedIn => false;

  @override
  String? get email => null;

  @override
  Future<void> signIn(String email, String password) async {
    throw const AuthFailure(
      'Sign in is not configured yet. Add your Supabase URL and publishable key.',
    );
  }

  @override
  Future<void> signOut() async {}
}
