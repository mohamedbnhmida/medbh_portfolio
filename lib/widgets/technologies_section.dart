import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medbh_portfolio/services/content_store.dart';
import 'package:medbh_portfolio/widgets/technology_card.dart';

class TechnologiesSection extends StatelessWidget {
  const TechnologiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Technologies",
          style: GoogleFonts.orbitron(
            fontSize: isMobile ? 22 : 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        _Marquee(
          itemExtent: (isMobile ? 110.0 : 130.0) + 20,
          children: [
            for (final tech in ContentStore.instance.technologies)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TechnologyCard(technology: tech),
              ),
          ],
        ),
      ],
    );
  }
}

/// Endless constant-speed scroll: the list is repeated and shifted by exactly one
/// list width per loop, so the wrap-around is invisible.
class _Marquee extends StatefulWidget {
  final double itemExtent;
  final List<Widget> children;
  const _Marquee({required this.itemExtent, required this.children});

  @override
  State<_Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<_Marquee>
    with SingleTickerProviderStateMixin {
  static const _pixelsPerSecond = 80.0;
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _loopDuration,
  )..repeat();

  double get _loopWidth => widget.itemExtent * widget.children.length;
  Duration get _loopDuration => Duration(
    milliseconds: (_loopWidth / _pixelsPerSecond * 1000).round().clamp(
      1,
      1 << 30,
    ),
  );

  @override
  void didUpdateWidget(_Marquee old) {
    super.didUpdateWidget(old);
    if (_controller.duration != _loopDuration) {
      _controller
        ..duration = _loopDuration
        ..repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.children.isEmpty) return const SizedBox.shrink();
    return LayoutBuilder(
      builder: (context, constraints) {
        // Enough copies to cover the viewport plus the one sliding out.
        final copies = (constraints.maxWidth / _loopWidth).ceil() + 1;
        return ClipRect(
          child: SizedBox(
            height: widget.itemExtent - 8,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => Transform.translate(
                offset: Offset(-_controller.value * _loopWidth, 0),
                child: child,
              ),
              child: OverflowBox(
                alignment: Alignment.centerLeft,
                maxWidth: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < copies; i++) ...widget.children,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
