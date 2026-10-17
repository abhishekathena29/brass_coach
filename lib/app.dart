import 'package:flutter/material.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/domain/auth_service.dart';

class BrassCoachApp extends StatefulWidget {
  const BrassCoachApp({super.key, required this.authService});

  final AuthService authService;

  @override
  State<BrassCoachApp> createState() => _BrassCoachAppState();
}

class _BrassCoachAppState extends State<BrassCoachApp> {
  late final _router = createAppRouter(widget.authService);

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BrassCoach AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
    );
  }
}
