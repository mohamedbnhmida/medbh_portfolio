import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medbh_portfolio/constants/app_data.dart';
import 'package:medbh_portfolio/widgets/technology_card.dart';

class TechnologiesSection extends StatelessWidget {
  const TechnologiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Technologies",
          style: GoogleFonts.orbitron(
            fontSize: MediaQuery.of(context).size.width < 600 ? 22 : 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        LayoutBuilder(
          builder: (context, constraints) {
            // Responsive viewport fraction:
            // Mobile (< 600): 0.35 (for square cards)
            // Tablet (< 900): 0.22
            // Desktop (> 900): 0.15
            double fraction = 0.15;
            if (constraints.maxWidth < 600) {
              fraction = 0.35; // Adjusted for square cards
            } else if (constraints.maxWidth < 900) {
              fraction = 0.22;
            }

            return CarouselSlider(
              options: CarouselOptions(
                height: 160.0, // Increased for square cards + shadows
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 2),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: false,
                viewportFraction: fraction, // Responsive fraction
                initialPage: 2,
              ),
              items: AppData.technologies.map((tech) {
                return Builder(
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                      ), // Reduced spacing
                      child: TechnologyCard(technology: tech),
                    );
                  },
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
