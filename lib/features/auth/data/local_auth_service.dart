import '../domain/auth_service.dart';

/// In-memory auth double used by widget tests; production uses FirebaseAuthService.
class LocalAuthService extends AuthService {
  bool _isSignedIn = false;
  String? _email;

  @override
  bool get isSignedIn => _isSignedIn;

  @override
  String? get email => _email;

  @override
  String? get uid => _isSignedIn ? 'test-user' : null;

  @override
  Future<void> signIn(String email, String password) async {
    _email = email.trim().isEmpty ? null : email.trim();
    _isSignedIn = true;
    notifyListeners();
  }

  @override
  Future<void> signUp(String email, String password) => signIn(email, password);

  @override
  Future<void> signOut() async {
    _email = null;
    _isSignedIn = false;
    notifyListeners();
  }
}
