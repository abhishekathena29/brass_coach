import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';

/// Port of the `StatusBar` sub-component inside `src/components/PhoneFrame.tsx`:
/// a dark, rounded-bottom header with a mock system clock row, the user's
/// avatar/account/instrument, and a notification button.
class PhoneStatusBar extends StatelessWidget {
  const PhoneStatusBar({super.key, required this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    final account = email?.isNotEmpty == true ? email! : 'Player';

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppRadii.xl4),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '9:41',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryForeground,
                ),
              ),
              Container(
                height: 24,
                width: 96,
                decoration: BoxDecoration(
                  color: AppColors.ink,
                  borderRadius: BorderRadius.circular(AppRadii.full),
                ),
              ),
              Text(
                '— ≋ ▮',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                  color: AppColors.primaryForeground,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      height: 44,
                      width: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.lilac,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        account[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            account,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.2,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryForeground,
                            ),
                          ),
                          Text(
                            'Trombone · Level 4',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0x99FBFAF8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 44,
                    width: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '♪',
                      style: TextStyle(fontSize: 18, color: AppColors.ink),
                    ),
                  ),
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: AppColors.lilacDeep,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
