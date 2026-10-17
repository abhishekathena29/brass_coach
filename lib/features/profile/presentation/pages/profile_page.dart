import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../shared/widgets/panel.dart';
import '../../../../shared/widgets/screen_scroll.dart';
import '../../../../shared/widgets/screen_title.dart';
import '../../../../shared/widgets/stat_tile.dart';
import '../widgets/settings_list.dart';

/// Port of `Profile` in `src/routes/profile.tsx`.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.email, required this.onSignOut});

  final String? email;
  final Future<void> Function() onSignOut;

  @override
  Widget build(BuildContext context) {
    return ScreenScroll(
      children: [
        ScreenTitle(title: 'Profile', sub: email ?? 'Your account'),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Panel(
            tone: PanelTone.lilac,
            child: const Row(
              children: [
                StatTile(label: 'Day streak', value: '9'),
                SizedBox(width: 8),
                StatTile(label: 'Awards', value: '15'),
                SizedBox(width: 8),
                StatTile(label: 'Badges', value: '6'),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Panel(
            tone: PanelTone.plain,
            bordered: true,
            padding: const EdgeInsets.all(8),
            child: const SettingsList(),
          ),
        ),
        Panel(
          tone: PanelTone.sage,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Practice reminder',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.foreground,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Weekdays at 6:30 PM, right after school hours.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: Material(
                  color: AppColors.ink,
                  borderRadius: BorderRadius.circular(AppRadii.full),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadii.full),
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        'Edit schedule',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryForeground,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
            child: const Text('Sign out'),
          ),
        ),
      ],
    );
  }
}
