import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Port of the `stripe-fill` utility in `src/styles.css`: a repeating
/// -45deg diagonal stripe over the fill color, used by [MeterRow] when
/// `striped: true`.
class StripeFill extends StatelessWidget {
  const StripeFill({super.key, required this.borderRadius});

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: borderRadius,
        child: CustomPaint(painter: _StripePainter()),
      ),
    );
  }
}

class _StripePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.ink.withValues(alpha: 0.07)
      ..strokeWidth = 6;

    const gap = 14.0;
    final diagonal = size.width + size.height;
    for (double x = -diagonal; x < diagonal; x += gap) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
