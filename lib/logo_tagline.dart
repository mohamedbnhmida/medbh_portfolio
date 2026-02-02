import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medbh_portfolio/constants/app_colors.dart';
import 'package:medbh_portfolio/constants/app_strings.dart';
import 'package:medbh_portfolio/widgets/typing_text.dart';

class LogoAndTagline extends StatelessWidget {
  const LogoAndTagline({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: isMobile
              ? 50
              : 120, // Reduced height on mobile to minimize space below animation
          child: TypingText(
            texts: const [
              "Mohamed Ben Hmida",
              "Mobile & Web Developer",
              "Software Engineer",
            ],
            style: GoogleFonts.orbitron(
              fontSize: isMobile ? 24 : 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            showCursor: true,
            cursorChar: '_',
          ),
        ),
      ],
    );
  }
}
