import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'app_bottom_nav.dart';
import 'phone_status_bar.dart';

/// Port of `PhoneFrame` from `src/components/PhoneFrame.tsx`: fixed status
/// bar on top, a scrollable body, and the floating bottom nav overlaid on
/// top of it — this is the persistent shell every tab renders inside.
class PhoneShell extends StatelessWidget {
  const PhoneShell({
    super.key,
    required this.body,
    required this.name,
    required this.instrument,
    required this.syncError,
    required this.currentIndex,
    required this.onTabTap,
  });

  final Widget body;
  final String name;
  final String instrument;
  final String? syncError;
  final int currentIndex;
  final ValueChanged<int> onTabTap;

  @override
  Widget build(BuildContext context) {
    AppColors.watch(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Column(
            children: [
              PhoneStatusBar(name: name, instrument: instrument),
              if (syncError != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  color: AppColors.destructive.withValues(alpha: 0.12),
                  child: Text(
                    'Your changes could not sync. Check your connection or Firebase setup.',
                    style: TextStyle(
                      color: AppColors.destructive,
                      fontSize: 13,
                    ),
                  ),
                ),
              Expanded(child: body),
            ],
          ),
          AppBottomNav(currentIndex: currentIndex, onTap: onTabTap),
        ],
      ),
    );
  }
}
