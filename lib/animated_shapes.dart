import 'dart:math' as math;

import 'package:flutter/material.dart';

class AnimatedShapes extends StatelessWidget {
  final AnimationController controller;
  final int? pointCount;
  const AnimatedShapes({required this.controller, this.pointCount});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: VerySlowFluidConnectingDotsPainter(
            controller.value,
            MediaQuery.of(context).size,
            count: pointCount,
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
  final int? count;
  late final List<Offset> _points;

  VerySlowFluidConnectingDotsPainter(
    this.animationValue,
    this.size, {
    this.count,
  }) {
    final random = math.Random(2); // Seed for consistency
    final actualCount = count ?? 10;
    _points = List.generate(
      actualCount,
      (_) => Offset(random.nextDouble(), random.nextDouble()),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = Colors.cyan.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = const Color.fromARGB(255, 20, 176, 233).withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.Random().nextDouble() * 0.5 + 0.5;

    final List<Offset> animatedPoints = _points.map((p) {
      final baseX = p.dx * size.width;
      final baseY = p.dy * size.height;

      final dx =
          baseX + 20 * math.sin(animationValue * 2 * math.pi + p.dy * 10);
      final dy =
          baseY + 120 * math.cos(animationValue * 2 * math.pi + p.dx * 10);

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
