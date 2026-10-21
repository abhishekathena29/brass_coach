import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'features/auth/data/local_auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = SharedPreferencesAsync();
  final darkMode = await preferences.getBool('dark_mode') ?? false;
  runApp(
    BrassCoachApp(
      authService: LocalAuthService(),
      initialDarkMode: darkMode,
      saveDarkMode: (value) => preferences.setBool('dark_mode', value),
    ),
  );
}
