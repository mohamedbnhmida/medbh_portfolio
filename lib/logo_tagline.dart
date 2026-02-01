import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medbh_portfolio/constants/app_colors.dart';
import 'package:medbh_portfolio/constants/app_strings.dart';

class LogoAndTagline extends StatelessWidget {
  const LogoAndTagline({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.name,
          style: GoogleFonts.orbitron(
            fontSize: isMobile ? 24 : 42, // Further reduced for mobile
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 8 : 12,
                vertical: isMobile ? 4 : 6,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderAccent),
              ),
              child: Text(
                AppStrings.tagline,
                style: GoogleFonts.orbitron(
                  fontSize: isMobile ? 12 : 16, // Further reduced for mobile
                  color: const Color.fromARGB(255, 82, 138, 235),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
