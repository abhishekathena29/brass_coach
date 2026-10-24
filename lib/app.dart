import 'package:flutter/material.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/domain/auth_service.dart';
import 'features/practice/data/practice_store.dart';

class BrassCoachApp extends StatefulWidget {
  const BrassCoachApp({
    super.key,
    required this.authService,
    this.practiceStore,
  });

  final AuthService authService;
  final PracticeStore? practiceStore;

  @override
  State<BrassCoachApp> createState() => _BrassCoachAppState();
}

class _BrassCoachAppState extends State<BrassCoachApp> {
  late final PracticeStore _store =
      widget.practiceStore ?? MemoryPracticeStore();
  late bool _darkMode;
  late final _router = createAppRouter(
    widget.authService,
    practiceStore: _store,
    onDarkModeChanged: (value) => _store.save({'darkMode': value}),
  );

  @override
  void initState() {
    super.initState();
    _darkMode = _store.data.darkMode;
    _store.addListener(_onStoreChanged);
  }

  void _onStoreChanged() {
    final darkMode = _store.data.darkMode;
    if (_darkMode != darkMode) {
      setState(() => _darkMode = darkMode);
    }
  }

  @override
  void dispose() {
    _router.dispose();
    _store.removeListener(_onStoreChanged);
    if (widget.practiceStore == null) _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppColors.isDark = _darkMode;
    return MaterialApp.router(
      title: 'BrassCoach AI',
      debugShowCheckedModeBanner: false,
      themeAnimationDuration: Duration.zero,
      theme: AppTheme.current,
      routerConfig: _router,
    );
  }
}
