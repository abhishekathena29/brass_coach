import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';

/// Port of `ScreenTitle` from `src/components/ui-kit.tsx`.
class ScreenTitle extends StatelessWidget {
  const ScreenTitle({super.key, required this.title, this.sub});

  final String title;
  final String? sub;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.quicksand(
              fontSize: 32,
              height: 1.15,
              letterSpacing: -0.5,
              fontWeight: FontWeight.w600,
              color: AppColors.foreground,
            ),
          ),
          if (sub != null) ...[
            const SizedBox(height: 4),
            Text(
              sub!,
              style: const TextStyle(fontSize: 14, color: AppColors.mutedForeground),
            ),
          ],
        ],
      ),
    );
  }
}
