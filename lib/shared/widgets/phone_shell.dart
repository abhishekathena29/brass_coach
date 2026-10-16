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
    required this.currentIndex,
    required this.onTabTap,
  });

  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onTabTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Column(
            children: [
              const PhoneStatusBar(),
              Expanded(
                child: body,
              ),
            ],
          ),
          AppBottomNav(currentIndex: currentIndex, onTap: onTabTap),
        ],
      ),
    );
  }
}
