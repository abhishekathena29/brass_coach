import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/panel.dart';
import '../../../../shared/widgets/screen_scroll.dart';
import '../../../practice/data/practice_store.dart';
import '../widgets/personal_details_form.dart';

class ProfileSetupPage extends StatelessWidget {
  const ProfileSetupPage({
    super.key,
    required this.store,
    required this.onSignOut,
  });

  final PracticeStore store;
  final Future<void> Function() onSignOut;

  @override
  Widget build(BuildContext context) {
    AppColors.watch(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ScreenScroll(
              children: [
                const SizedBox(height: 24),
                Text(
                  'Make it yours',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tell us about your playing. You can change these details anytime in Profile.',
                  style: TextStyle(color: AppColors.mutedForeground),
                ),
                const SizedBox(height: 24),
                Panel(
                  tone: PanelTone.plain,
                  bordered: true,
                  child: PersonalDetailsForm(store: store, isSetup: true),
                ),
                const SizedBox(height: 14),
                TextButton(
                  onPressed: () async {
                    try {
                      await onSignOut();
                    } catch (_) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Could not sign out.')),
                        );
                      }
                    }
                  },
                  child: const Text('Sign out'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
