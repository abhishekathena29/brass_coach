import 'package:flutter/foundation.dart';

abstract class AuthService extends ChangeNotifier {
  bool get isSignedIn;
  String? get email;
  String? get uid;

  Future<void> signIn(String email, String password);
  Future<void> signUp(String email, String password);

  Future<void> signOut();
}
