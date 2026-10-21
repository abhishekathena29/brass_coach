import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Port of the pitch-lane `<svg>` in `src/routes/practice.tsx`: a solid
/// reference curve, a dashed "you" curve with a gradient fill beneath it,
/// and four horizontal grid lines. Coordinates match the original
/// `viewBox="0 0 320 120"` bezier paths, scaled to the available width.
class PitchLaneChart extends StatelessWidget {
  const PitchLaneChart({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 320 / 120,
      child: CustomPaint(painter: _PitchLanePainter()),
    );
  }
}

class _PitchLanePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 320;
    final sy = size.height / 120;
    Offset p(double x, double y) => Offset(x * sx, y * sy);

    final gridPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    for (final y in [20.0, 50.0, 80.0, 110.0]) {
      canvas.drawLine(p(0, y), p(320, y), gridPaint);
    }

    final reference = Path()
      ..moveTo(p(0, 80).dx, p(0, 80).dy)
      ..cubicTo(p(40, 40).dx, p(40, 40).dy, p(70, 40).dx, p(70, 40).dy, p(100, 62).dx, p(100, 62).dy)
      ..cubicTo(p(130, 84).dx, p(130, 84).dy, p(160, 30).dx, p(160, 30).dy, p(200, 55).dx, p(200, 55).dy)
      ..cubicTo(p(240, 80).dx, p(240, 80).dy, p(270, 70).dx, p(270, 70).dy, p(320, 44).dx, p(320, 44).dy);

    final youLine = Path()
      ..moveTo(p(0, 88).dx, p(0, 88).dy)
      ..cubicTo(p(40, 52).dx, p(40, 52).dy, p(70, 30).dx, p(70, 30).dy, p(100, 70).dx, p(100, 70).dy)
      ..cubicTo(p(130, 110).dx, p(130, 110).dy, p(160, 22).dx, p(160, 22).dy, p(200, 68).dx, p(200, 68).dy)
      ..cubicTo(p(240, 114).dx, p(240, 114).dy, p(270, 58).dx, p(270, 58).dy, p(320, 52).dx, p(320, 52).dy);

    final fillArea = Path.from(youLine)
      ..lineTo(p(320, 120).dx, p(320, 120).dy)
      ..lineTo(p(0, 120).dx, p(0, 120).dy)
      ..close();

    canvas.drawPath(
      fillArea,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.lilacDeep.withValues(alpha: 0.35),
            AppColors.lilacDeep.withValues(alpha: 0.05),
          ],
        ).createShader(Offset.zero & size),
    );

    canvas.drawPath(
      reference,
      Paint()
        ..color = AppColors.ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );

    _drawDashedPath(
      canvas,
      youLine,
      Paint()
        ..color = AppColors.sageDeep
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dashLength = 5.0;
    const gapLength = 5.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      var draw = true;
      while (distance < metric.length) {
        final next = distance + (draw ? dashLength : gapLength);
        if (draw) {
          canvas.drawPath(metric.extractPath(distance, next.clamp(0, metric.length)), paint);
        }
        distance = next;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
