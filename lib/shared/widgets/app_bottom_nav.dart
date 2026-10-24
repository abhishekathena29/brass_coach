import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';

class NavItem {
  const NavItem(this.icon, this.label);
  final IconData icon;
  final String label;
}

const List<NavItem> kNavItems = [
  NavItem(LucideIcons.gauge, 'Today'),
  NavItem(LucideIcons.music2, 'Practice'),
  NavItem(LucideIcons.library, 'Library'),
  NavItem(LucideIcons.medal, 'Progress'),
  NavItem(LucideIcons.user, 'Profile'),
];

/// Port of `BottomNav` from `src/components/BottomNav.tsx`: a floating
/// pill-shaped dock, pinned near the bottom of the phone frame, whose
/// active tab morphs from translucent icon to a solid card-colored circle.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    AppColors.watch(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.ink,
            borderRadius: BorderRadius.circular(999),
            boxShadow: AppShadows.float,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < kNavItems.length; i++)
                _NavButton(
                  item: kNavItems[i],
                  active: i == currentIndex,
                  onTap: () => onTap(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.active,
    required this.onTap,
  });

  final NavItem item;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Semantics(
          label: item.label,
          button: true,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 52,
            width: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? AppColors.card : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.icon,
              size: 20,
              color: active
                  ? AppColors.foreground
                  : AppColors.primaryForeground.withValues(alpha: 0.8),
            ),
          ),
        ),
      ),
    );
  }
}
