import 'dart:math' as math;
import 'package:flutter/material.dart';

class RandomCurves extends StatefulWidget {
  const RandomCurves({super.key});

  @override
  State<RandomCurves> createState() => _RandomCurvesState();
}

class _RandomCurvesState extends State<RandomCurves>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(200, 200),
          painter: CurvePainter(_controller.value),
        );
      },
    );
  }
}

class CurvePainter extends CustomPainter {
  final double animationValue;

  CurvePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    for (int i = 0; i < 3; i++) {
      final curvePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0 - (i * 0.5)
        ..shader = LinearGradient(
          colors: [
            Colors.blueAccent.withOpacity(0.8 - (i * 0.2)),
            Colors.cyanAccent.withOpacity(0.4 - (i * 0.1)),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

      final path = Path();
      final phase = animationValue * 2 * math.pi;
      final offset = i * math.pi / 2;

      path.moveTo(
        centerX + math.cos(phase + offset) * 50,
        centerY + math.sin(phase + offset) * 50,
      );

      for (int j = 1; j <= 4; j++) {
        final angle = phase + offset + (j * math.pi / 2);
        final nextAngle = angle + (math.pi / 2);

        final cp1x =
            centerX + math.cos(angle) * (80 + 20 * math.sin(phase * 2 + i));
        final cp1y =
            centerY + math.sin(angle) * (80 + 20 * math.cos(phase * 2 + i));

        final cp2x =
            centerX + math.cos(nextAngle) * (30 + 10 * math.cos(phase * 3 + i));
        final cp2y =
            centerY + math.sin(nextAngle) * (30 + 10 * math.sin(phase * 3 + i));

        final endX = centerX + math.cos(nextAngle) * 50;
        final endY = centerY + math.sin(nextAngle) * 50;

        path.cubicTo(cp1x, cp1y, cp2x, cp2y, endX, endY);
      }

      canvas.drawPath(path, curvePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CurvePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
