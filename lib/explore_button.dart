import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medbh_portfolio/constants/app_colors.dart';

class ExploreButton extends StatelessWidget {
  final VoidCallback? onTap;

  const ExploreButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.floatingButtonBackground,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: onTap,
      child: Text(
        'Explore My Work',
        style: GoogleFonts.orbitron(
          fontSize: isMobile ? 15 : 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
