import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medbh_portfolio/constants/app_colors.dart';
import 'package:medbh_portfolio/models/technology_model.dart';

class TechnologyCard extends StatelessWidget {
  final TechnologyModel technology;

  const TechnologyCard({super.key, required this.technology});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderAccent),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (technology.assetPath != null)
            Image.asset(
              technology.assetPath!,
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            )
          else
            Icon(
              technology.icon ?? Icons.code, // Fallback
              size: 32,
              color: technology.color,
            ),
          const SizedBox(height: 8),
          Text(
            technology.name,
            textAlign: TextAlign.center,
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
