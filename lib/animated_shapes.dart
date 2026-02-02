import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedShapes extends StatefulWidget {
  @override
  _AnimatedShapesState createState() => _AnimatedShapesState();
}

class _AnimatedShapesState extends State<AnimatedShapes>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
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
        return Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: Container(
            width: 150,
            height: 150,
            child: Stack(
              children: List.generate(3, (index) {
                return Transform.rotate(
                  angle: (index / 3) * 2 * math.pi,
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: Colors.lightBlueAccent.withOpacity(0.6),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
