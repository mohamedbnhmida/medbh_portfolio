import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medbh_portfolio/constants/app_data.dart';
import 'package:medbh_portfolio/widgets/project_card.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _activeTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() => _activeTab = _tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildCarousel({required bool isDesktop, required bool isWebDesktop}) {
    final projects =
        isWebDesktop ? AppData.webDesktopProjects : AppData.mobileProjects;

    final double height = isWebDesktop
        ? (isDesktop ? 440.0 : 320.0)
        : (isDesktop ? 600.0 : 500.0);
    final double fraction;
    final double enlargeFactor;

    if (isWebDesktop) {
      fraction = isDesktop ? 0.52 : 0.92;
      enlargeFactor = isDesktop ? 0.06 : 0.08;
    } else {
      fraction = isDesktop ? 0.22 : 0.88;
      enlargeFactor = isDesktop ? 0.1 : 0.08;
    }

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
      items: projects.map((project) {
        return Builder(
          builder: (BuildContext context) {
            return ProjectCard(project: project);
          },
        );
      }).toList(),
    );
  }

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
        const SizedBox(height: 20),

        // Tab Bar
        TabBar(
          controller: _tabController,
          isScrollable: false,
          indicatorColor: Colors.blueAccent,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white38,
          dividerColor: Colors.white12,
          tabAlignment: TabAlignment.fill,
          tabs: [
            Tab(
              height: 56,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.phone_android, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    "Mobile",
                    style: GoogleFonts.orbitron(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              height: 56,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.desktop_windows_outlined, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    "Web & Desktop",
                    style: GoogleFonts.orbitron(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Tab Content
        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 800;
            final mobileHeight = _activeTab == 1 ? 360.0 : 540.0;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: isDesktop ? 620.0 : mobileHeight,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCarousel(isDesktop: isDesktop, isWebDesktop: false),
                  _buildCarousel(isDesktop: isDesktop, isWebDesktop: true),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
