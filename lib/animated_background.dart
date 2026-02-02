import 'package:flutter/material.dart';

class AnimatedColorCyclingGradient extends StatelessWidget {
  final AnimationController controller;

  const AnimatedColorCyclingGradient({required this.controller});

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color.fromARGB(255, 4, 6, 10),
      const Color.fromARGB(255, 11, 4, 32),
      const Color.fromARGB(255, 13, 27, 60),
      const Color.fromARGB(255, 8, 20, 39),
      const Color.fromARGB(255, 0, 0, 0), // Loop back to the start
    ];

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final double value = controller.value;
        final double colorIndex = value * (colors.length - 1);
        final int startIndex = colorIndex.floor();
        final double fraction = colorIndex - startIndex;
        final Color startColor = colors[startIndex];
        final Color endColor = colors[(startIndex + 1) % colors.length];
        final Color interpolatedColor1 = Color.lerp(
          startColor,
          endColor,
          fraction,
        )!;

        final double colorIndex2 =
            (value + 0.3) %
            1 *
            (colors.length - 1); // Offset for the second color
        final int startIndex2 = colorIndex2.floor();
        final double fraction2 = colorIndex2 - startIndex2;
        final Color startColor2 = colors[startIndex2];
        final Color endColor2 = colors[(startIndex2 + 1) % colors.length];
        final Color interpolatedColor2 = Color.lerp(
          startColor2,
          endColor2,
          fraction2,
        )!;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [interpolatedColor1, interpolatedColor2],
            ),
          ),
        );
      },
    );
  }
}
