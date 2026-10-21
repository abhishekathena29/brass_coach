import '../domain/auth_service.dart';

/// Temporary, in-memory access for exploring the app without a backend.
class LocalAuthService extends AuthService {
  bool _isSignedIn = false;
  String? _email;

  @override
  bool get isSignedIn => _isSignedIn;

  @override
  String? get email => _email;

  @override
  Future<void> signIn(String email, String password) async {
    _email = email.trim().isEmpty ? null : email.trim();
    _isSignedIn = true;
    notifyListeners();
  }

  @override
  Future<void> signOut() async {
    _email = null;
    _isSignedIn = false;
    notifyListeners();
  }
}
