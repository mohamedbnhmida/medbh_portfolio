import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medbh_portfolio/constants/app_colors.dart';
import 'package:medbh_portfolio/models/technology_model.dart';

class TechnologyCard extends StatelessWidget {
  final TechnologyModel technology;

  const TechnologyCard({super.key, required this.technology});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final size = isMobile ? 110.0 : 130.0;

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderAccent, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (technology.assetPath != null)
            Image.asset(
              technology.assetPath!,
              width: isMobile ? 32 : 40,
              height: isMobile ? 32 : 40,
              fit: BoxFit.contain,
            )
          else
            Icon(
              technology.icon ?? Icons.code,
              size: isMobile ? 32 : 40,
              color: technology.color,
            ),
          const SizedBox(height: 12),
          Text(
            technology.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: isMobile ? 10 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
