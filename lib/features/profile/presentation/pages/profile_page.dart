import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/panel.dart';
import '../../../../shared/widgets/screen_scroll.dart';
import '../../../../shared/widgets/screen_title.dart';
import '../../../../shared/widgets/stat_tile.dart';
import '../../../practice/data/practice_store.dart';
import '../widgets/personal_details_form.dart';

/// Port of `Profile` in `src/routes/profile.tsx`.
class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.email,
    required this.onSignOut,
    required this.onDarkModeChanged,
    required this.store,
  });

  final String? email;
  final Future<void> Function() onSignOut;
  final Future<void> Function(bool) onDarkModeChanged;
  final PracticeStore store;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) => ScreenScroll(
        children: [
          ScreenTitle(
            title: 'Profile',
            sub: 'Your practice, ${store.data.displayName}',
          ),
          Text('About you', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Panel(
              tone: PanelTone.plain,
              bordered: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(store.data.goal),
                  const SizedBox(height: 4),
                  Text(
                    '${store.data.instrument} · ${store.data.level}',
                    style: TextStyle(color: AppColors.mutedForeground),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: const EdgeInsets.only(bottom: 8),
                      title: const Text('Edit your details'),
                      children: [PersonalDetailsForm(store: store)],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text('Your activity', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Panel(
              tone: PanelTone.lilac,
              child: Row(
                children: [
                  StatTile(
                    label: 'Sessions',
                    value: '${store.sessions.length}',
                  ),
                  const SizedBox(width: 8),
                  StatTile(
                    label: 'This week',
                    value:
                        '${store.sessions.where((session) => session.at.isAfter(DateTime.now().subtract(const Duration(days: 7)))).length}',
                  ),
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
                  value: store.data.darkMode,
                  onChanged: (value) async {
                    try {
                      await onDarkModeChanged(value);
                    } catch (_) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Could not save dark mode. Try again.',
                            ),
                          ),
                        );
                      }
                    }
                  },
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
              'Signed in as ${email ?? 'your account'}',
              style: TextStyle(color: AppColors.foreground),
            ),
          ),
          if (store.error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                store.error!,
                style: TextStyle(color: AppColors.destructive),
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
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(error.toString())));
                  }
                }
              },
              child: const Text('Sign out'),
            ),
          ),
        ],
      ),
    );
  }
}
