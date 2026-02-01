import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderButton extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;

  const HeaderButton({Key? key, required this.text, this.onTap})
    : super(key: key);

  @override
  State<HeaderButton> createState() => _HeaderButtonState();
}

class _HeaderButtonState extends State<HeaderButton> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    // Check for mobile screen size
    final isMobile = MediaQuery.of(context).size.width < 600;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: GoogleFonts.orbitron(
            color: isHovering ? Colors.blueAccent : Colors.white,
            fontSize: isMobile ? 14 : 16, // Smaller font on mobile
            fontWeight: isHovering ? FontWeight.bold : FontWeight.normal,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 8.0 : 12.0, // Smaller padding on mobile
              vertical: isMobile ? 6.0 : 8.0,
            ),
            child: Text(widget.text),
          ),
        ),
      ),
    );
  }
}
