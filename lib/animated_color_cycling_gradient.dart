import 'package:flutter/material.dart';

class AnimatedColorCyclingGradient extends StatefulWidget {
  @override
  _AnimatedColorCyclingGradientState createState() =>
      _AnimatedColorCyclingGradientState();
}

class _AnimatedColorCyclingGradientState
    extends State<AnimatedColorCyclingGradient> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation1;
  late Animation<Color?> _colorAnimation2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    _colorAnimation1 = ColorTween(
      begin: Colors.blue.withOpacity(0.5),
      end: Colors.purple.withOpacity(0.5),
    ).animate(_controller);

    _colorAnimation2 = ColorTween(
      begin: Colors.black,
      end: Colors.deepPurple.withOpacity(0.8),
    ).animate(_controller);
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
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_colorAnimation1.value!, _colorAnimation2.value!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        );
      },
    );
  }
}
