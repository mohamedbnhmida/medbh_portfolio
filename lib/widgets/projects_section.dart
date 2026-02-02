import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medbh_portfolio/constants/app_data.dart';
import 'package:medbh_portfolio/widgets/project_card.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Projects",
          style: GoogleFonts.orbitron(
            fontSize: MediaQuery.of(context).size.width < 600 ? 22 : 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        LayoutBuilder(
          builder: (context, constraints) {
            // Distinct configurations for Mobile vs Desktop (Split View approach)
            final isDesktop = constraints.maxWidth > 800;

            final double height = isDesktop ? 600.0 : 500.0;
            // Mobile: 0.4 to show ~2.5-3 items. Desktop: 0.22 to show ~4-5 items.
            final double fraction = isDesktop ? 0.22 : 0.75;
            // Keep effect subtle on both so side items are readable
            final double enlargeFactor = isDesktop ? 0.1 : 0.15;

            return CarouselSlider(
              options: CarouselOptions(
                height: height,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
                enlargeCenterPage: true,
                enlargeFactor: enlargeFactor,
                viewportFraction: fraction,
                aspectRatio: 2 / 3,
                enableInfiniteScroll: true,
              ),
              items: AppData.projects.map((project) {
                return Builder(
                  builder: (BuildContext context) {
                    return ProjectCard(project: project);
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
