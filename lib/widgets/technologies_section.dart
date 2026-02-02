import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medbh_portfolio/constants/app_data.dart';
import 'package:medbh_portfolio/widgets/technology_card.dart';

class TechnologiesSection extends StatelessWidget {
  const TechnologiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final isTablet = width < 900;

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
        CarouselSlider(
          options: CarouselOptions(
            height: isMobile ? 110.0 : 130.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 2),
            autoPlayCurve: Curves.fastOutSlowIn,
            viewportFraction: isMobile ? 0.35 : (isTablet ? 0.20 : 0.12),
            enlargeCenterPage: false,
            initialPage: 2,
          ),
          items: AppData.technologies
              .map(
                (tech) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: TechnologyCard(technology: tech),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
