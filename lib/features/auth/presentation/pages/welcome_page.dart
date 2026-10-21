import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headlineLarge?.copyWith(
      fontSize: 38,
      height: 1.1,
      fontWeight: FontWeight.w700,
      letterSpacing: -1.2,
      color: AppColors.foreground,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 480,
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      children: [
                        SizedBox(height: 24),
                        Row(
                          children: [
                            Icon(
                              LucideIcons.music2,
                              color: AppColors.ink,
                              size: 25,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'BrassCoach AI',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 210,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.lilacSoft,
                                  borderRadius: BorderRadius.circular(
                                    AppRadii.xl3,
                                  ),
                                ),
                                child: Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        height: 146,
                                        width: 146,
                                        decoration: BoxDecoration(
                                          color: AppColors.lilac,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Icon(
                                        LucideIcons.audioLines,
                                        size: 76,
                                        color: AppColors.ink,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 36),
                              Text('Practice with purpose.', style: titleStyle),
                              SizedBox(height: 12),
                              Text(
                                'Get clear feedback on your playing and make every brass practice session count.',
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: AppColors.mutedForeground,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: FilledButton(
                            onPressed: () => context.go('/sign-in'),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.ink,
                              foregroundColor: AppColors.primaryForeground,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadii.full,
                                ),
                              ),
                            ),
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 28),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
