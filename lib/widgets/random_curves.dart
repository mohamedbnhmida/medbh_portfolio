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

    for (int i = 0; i < 5; i++) {
      final curvePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5 - (i * 0.4)
        ..shader = LinearGradient(
          colors: [
            Colors.blueAccent.withOpacity(0.9 - (i * 0.15)),
            Colors.cyanAccent.withOpacity(0.5 - (i * 0.08)),
            Colors.deepPurpleAccent.withOpacity(0.3 - (i * 0.05)),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

      final path = Path();
      final phase = animationValue * 2 * math.pi;
      final offset = i * math.pi / 2.5;

      final startR = 40 + 15 * math.sin(phase + i * 1.5);
      path.moveTo(
        centerX + math.cos(phase + offset) * startR,
        centerY + math.sin(phase + offset) * startR,
      );

      for (int j = 1; j <= 6; j++) {
        final angle = phase + offset + (j * math.pi / 3);
        final nextAngle = angle + (math.pi / 3);

        final r1 = 90 + 30 * math.sin(phase * 2.5 + i * 2 + j);
        final cp1x = centerX + math.cos(angle) * r1;
        final cp1y = centerY + math.sin(angle) * r1;

        final r2 = 40 + 20 * math.cos(phase * 3.7 + i + j * 0.5);
        final cp2x = centerX + math.cos(nextAngle) * r2;
        final cp2y = centerY + math.sin(nextAngle) * r2;

        final endR = 40 + 15 * math.sin(phase + i * 1.5 + j);
        final endX = centerX + math.cos(nextAngle) * endR;
        final endY = centerY + math.sin(nextAngle) * endR;

        path.cubicTo(cp1x, cp1y, cp2x, cp2y, endX, endY);
      }
      path.close();

      canvas.drawPath(path, curvePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CurvePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
