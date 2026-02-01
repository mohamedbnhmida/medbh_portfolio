import 'dart:math';
import 'package:flutter/material.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({super.key});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
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
        final screenWidth = MediaQuery.of(context).size.width;
        final imageSize = screenWidth < 600 ? screenWidth * 0.7 : 400.0;

        return CustomPaint(
          painter: OrganicBorderPainter(
            color: Colors.white,
            animationValue: _controller.value,
          ),
          child: Container(
            width: imageSize,
            height: imageSize,
            padding: const EdgeInsets.all(1), // Space for the border
            child: ClipPath(
              clipper: OrganicBlobClipper(animationValue: _controller.value),
              child: Image.asset('assets/icon.png', fit: BoxFit.cover),
            ),
          ),
        );
      },
    );
  }
}

class OrganicBlobClipper extends CustomClipper<Path> {
  final double animationValue;

  OrganicBlobClipper({required this.animationValue});

  @override
  Path getClip(Size size) {
    return _createOrganicPath(size, animationValue);
  }

  @override
  bool shouldReclip(covariant OrganicBlobClipper oldClipper) {
    return true;
  }
}

class OrganicBorderPainter extends CustomPainter {
  final Color color;
  final double animationValue;

  OrganicBorderPainter({required this.color, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final path = _createOrganicPath(size, animationValue);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant OrganicBorderPainter oldDelegate) {
    return true;
  }
}

// Helper to create the morphing path
Path _createOrganicPath(Size size, double animValue) {
  final path = Path();
  final w = size.width;
  final h = size.height;

  final centerX = w / 2;
  final centerY = h / 2;
  final radius = min(w, h) / 2;

  // We'll create a smooth blob by using sine waves on the radius
  // 8 points around the circle
  final points = <Offset>[];
  final count = 8;

  for (int i = 0; i < count; i++) {
    double angle = (i * 2 * pi) / count;

    // Offset each point based on animation
    // Using different frequencies/phases for "random" organic feel without actual randomness
    double offset =
        sin(angle * 3 + animValue * 2 * pi) * 15 +
        cos(angle * 2 + animValue * 4 * pi) * 10;

    double r = radius + offset - 20; // -20 to keep inside bounds

    points.add(Offset(centerX + r * cos(angle), centerY + r * sin(angle)));
  }

  // Draw smooth curve through points
  // Re-doing loop for "Midpoint to Midpoint" smoothing
  path.reset();

  // Start at midpoint between last and first
  final pLast = points.last;
  final pFirst = points.first;
  var currentMid = Offset(
    (pLast.dx + pFirst.dx) / 2,
    (pLast.dy + pFirst.dy) / 2,
  );

  path.moveTo(currentMid.dx, currentMid.dy);

  for (int i = 0; i < points.length; i++) {
    final p1 = points[i];
    final pNext = points[(i + 1) % points.length];
    final nextMid = Offset((p1.dx + pNext.dx) / 2, (p1.dy + pNext.dy) / 2);

    path.quadraticBezierTo(p1.dx, p1.dy, nextMid.dx, nextMid.dy);
  }

  path.close();
  return path;
}
