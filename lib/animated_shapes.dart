import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedShapes extends StatelessWidget {
  final AnimationController controller;
  const AnimatedShapes({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: VerySlowFluidConnectingDotsPainter(
            controller.value,
            MediaQuery.of(context).size,
          ),
          size: MediaQuery.of(context).size,
        );
      },
    );
  }
}

class VerySlowFluidConnectingDotsPainter extends CustomPainter {
  final double animationValue;
  final Size size;

  static final List<Offset> _staticPoints = List.generate(
    Random().nextInt(100),
    (_) => Offset(Random().nextDouble(), Random().nextDouble()),
  );

  VerySlowFluidConnectingDotsPainter(this.animationValue, this.size);

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = Colors.cyan.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Color.fromARGB(255, 20, 176, 233).withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = Random().nextDouble() * 0.5 + 0.5;

    final List<Offset> animatedPoints = _staticPoints.map((p) {
      final baseX = p.dx * size.width;
      final baseY = p.dy * size.height;

      final dx = baseX + 100 * sin(animationValue * 2 * pi + p.dy * 100);
      final dy = baseY + 220 * cos(animationValue * 2 * pi + p.dx * 30);

      return Offset(dx, dy);
    }).toList();

    for (final point in animatedPoints) {
      canvas.drawCircle(point, 3, dotPaint);
    }

    for (int i = 0; i < animatedPoints.length; i++) {
      for (int j = i + 1; j < animatedPoints.length; j++) {
        double distance = (animatedPoints[i] - animatedPoints[j]).distance;
        if (distance < 200) {
          canvas.drawLine(animatedPoints[i], animatedPoints[j], linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
