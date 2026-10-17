import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'features/auth/data/supabase_auth_service.dart';
import 'features/auth/domain/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const url = String.fromEnvironment('SUPABASE_URL');
  const publishableKey = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

  final AuthService authService;
  if (url.isNotEmpty && publishableKey.isNotEmpty) {
    await Supabase.initialize(url: url, publishableKey: publishableKey);
    authService = SupabaseAuthService(Supabase.instance.client);
  } else {
    authService = UnconfiguredAuthService();
  }

  runApp(BrassCoachApp(authService: authService));
}
