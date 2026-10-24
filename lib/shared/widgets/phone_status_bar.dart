import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';

/// Header with the player's chosen name and instrument.
class PhoneStatusBar extends StatelessWidget {
  const PhoneStatusBar({
    super.key,
    required this.name,
    required this.instrument,
  });

  final String name;
  final String instrument;

  @override
  Widget build(BuildContext context) {
    AppColors.watch(context);
    final account = name;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
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
                            instrument,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.primaryForeground.withValues(
                                alpha: 0.82,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
