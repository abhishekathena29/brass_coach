import 'package:flutter/material.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/domain/auth_service.dart';

class BrassCoachApp extends StatefulWidget {
  const BrassCoachApp({
    super.key,
    required this.authService,
    this.initialDarkMode = false,
    this.saveDarkMode,
  });

  final AuthService authService;
  final bool initialDarkMode;
  final Future<void> Function(bool)? saveDarkMode;

  @override
  State<BrassCoachApp> createState() => _BrassCoachAppState();
}

class _BrassCoachAppState extends State<BrassCoachApp> {
  late bool _darkMode = widget.initialDarkMode;
  late final _router = createAppRouter(
    widget.authService,
    darkMode: () => _darkMode,
    onDarkModeChanged: (value) {
      setState(() => _darkMode = value);
      widget.saveDarkMode?.call(value);
    },
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppColors.isDark = _darkMode;
    return MaterialApp.router(
      key: ValueKey(_darkMode),
      title: 'BrassCoach AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.current,
      routerConfig: _router,
    );
  }
}
