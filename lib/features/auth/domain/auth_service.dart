import 'package:flutter/foundation.dart';

class AuthFailure implements Exception {
  const AuthFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

abstract class AuthService extends ChangeNotifier {
  bool get isSignedIn;
  String? get email;

  Future<void> signIn(String email, String password);

  Future<void> signOut();
}
