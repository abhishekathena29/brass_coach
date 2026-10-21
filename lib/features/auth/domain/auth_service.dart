import 'package:flutter/foundation.dart';

abstract class AuthService extends ChangeNotifier {
  bool get isSignedIn;
  String? get email;

  Future<void> signIn(String email, String password);

  Future<void> signOut();
}
