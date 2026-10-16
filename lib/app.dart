import 'package:flutter/material.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// Port of `src/routes/__root.tsx` + `src/router.tsx`: app-wide theme and
/// the router that wraps every screen.
class BrassCoachApp extends StatelessWidget {
  const BrassCoachApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BrassCoach AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
