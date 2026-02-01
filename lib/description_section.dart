import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medbh_portfolio/constants/app_strings.dart';

class DescriptionSection extends StatelessWidget {
  const DescriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About Me',
          style: GoogleFonts.orbitron(
            fontSize: isMobile ? 22 : 28, // Reduced for mobile
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.only(right: isMobile ? 0 : 24),
          child: Text(
            AppStrings.aboutMe,
            style: GoogleFonts.orbitron(
              color: Colors.white70,
              fontSize: isMobile ? 14 : 16, // Reduced for mobile
              height: 1.5,
              wordSpacing: 2,
            ),
          ),
        ),
      ],
    );
  }
}
