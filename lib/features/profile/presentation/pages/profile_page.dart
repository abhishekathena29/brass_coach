import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/panel.dart';
import '../../../../shared/widgets/screen_scroll.dart';
import '../../../../shared/widgets/screen_title.dart';
import '../../../../shared/widgets/stat_tile.dart';

/// Port of `Profile` in `src/routes/profile.tsx`.
class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.email,
    required this.onSignOut,
    required this.darkMode,
    required this.onDarkModeChanged,
  });

  final String? email;
  final Future<void> Function() onSignOut;
  final bool darkMode;
  final ValueChanged<bool> onDarkModeChanged;

  @override
  Widget build(BuildContext context) {
    return ScreenScroll(
      children: [
        ScreenTitle(title: 'Profile', sub: email ?? 'Your practice space'),
        Text('Your activity', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Panel(
            tone: PanelTone.lilac,
            child: const Row(
              children: [
                StatTile(label: 'Streak', value: '9'),
                SizedBox(width: 8),
                StatTile(label: 'Sessions', value: '15'),
                SizedBox(width: 8),
                StatTile(label: 'Goals met', value: '6'),
              ],
            ),
          ),
        ),
        Text('Appearance', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Panel(
            tone: PanelTone.plain,
            bordered: true,
            padding: EdgeInsets.zero,
            child: Material(
              color: Colors.transparent,
              child: SwitchListTile.adaptive(
                title: const Text('Dark mode'),
                subtitle: const Text('Use a darker theme throughout the app'),
                value: darkMode,
                onChanged: onDarkModeChanged,
              ),
            ),
          ),
        ),
        Text('Account', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        Panel(
          tone: PanelTone.plain,
          bordered: true,
          child: Text(
            email == null
                ? 'Browsing without an account'
                : 'Signed in as $email',
            style: TextStyle(color: AppColors.foreground),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: TextButton(
            onPressed: () async {
              try {
                await onSignOut();
              } catch (error) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(error.toString())));
                }
              }
            },
            child: const Text('Return to welcome'),
          ),
        ),
      ],
    );
  }
}
