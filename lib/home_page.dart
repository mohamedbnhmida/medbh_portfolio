import 'package:flutter/material.dart';
import 'package:medbh_portfolio/animated_background.dart';
import 'package:medbh_portfolio/animated_shapes.dart';
import 'package:medbh_portfolio/constants/app_colors.dart';
import 'package:medbh_portfolio/description_section.dart';
import 'package:medbh_portfolio/explore_button.dart';
import 'package:medbh_portfolio/header.dart';
import 'package:medbh_portfolio/logo_tagline.dart';
import 'package:medbh_portfolio/widgets/contact_section.dart';
import 'package:medbh_portfolio/widgets/download_cv_button.dart';
import 'package:medbh_portfolio/widgets/profile_image.dart';
import 'package:medbh_portfolio/widgets/projects_section.dart';
import 'package:medbh_portfolio/widgets/technologies_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _bgController;
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _technologiesKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  bool _showBackToTop = false;
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 50),
    )..repeat();

    _scrollController.addListener(() {
      if (_scrollController.offset > 300 && !_showBackToTop) {
        setState(() => _showBackToTop = true);
      } else if (_scrollController.offset <= 300 && _showBackToTop) {
        setState(() => _showBackToTop = false);
      }

      if (_scrollController.offset > 20 && !_isScrolled) {
        setState(() => _isScrolled = true);
      } else if (_scrollController.offset <= 20 && _isScrolled) {
        setState(() => _isScrolled = false);
      }
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToSection(int index) {
    if (index == 0) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else if (index == 1) {
      if (_technologiesKey.currentContext != null) {
        Scrollable.ensureVisible(
          _technologiesKey.currentContext!,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: 0.0,
        );
      }
    } else if (index == 2) {
      if (_projectsKey.currentContext != null) {
        Scrollable.ensureVisible(
          _projectsKey.currentContext!,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: 0.0,
        );
      }
    } else if (index == 3) {
      if (_contactKey.currentContext != null) {
        Scrollable.ensureVisible(
          _contactKey.currentContext!,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: 0.0,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1A),
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedColorCyclingGradient(controller: _bgController),
            AnimatedShapes(
              controller: _bgController,
              pointCount: isMobile ? 20 : 50,
            ),
            SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width < 600 ? 80 : 120,
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 800) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  LogoAndTagline(),
                                  SizedBox(height: 40),
                                  DescriptionSection(),
                                ],
                              ),
                            ),
                            const SizedBox(width: 40),
                            const ProfileImage(),
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            ProfileImage(),
                            SizedBox(height: 20),
                            LogoAndTagline(),
                            SizedBox(height: 30),
                            DescriptionSection(),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: isMobile
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ExploreButton(onTap: () => scrollToSection(2)),
                              const SizedBox(height: 16),
                              const DownloadCVButton(),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ExploreButton(onTap: () => scrollToSection(2)),
                              const SizedBox(width: 30),
                              const DownloadCVButton(),
                            ],
                          ),
                  ),
                  const SizedBox(height: 100),
                  SizedBox(key: _technologiesKey, height: 100),
                  const TechnologiesSection(),
                  const SizedBox(height: 80),
                  SizedBox(key: _projectsKey, height: 100),
                  const ProjectsSection(),
                  const SizedBox(height: 80),
                  SizedBox(key: _contactKey, height: 100),
                  const ContactSection(),
                  const SizedBox(height: 60),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ResponsiveHeader(
                onNavTap: scrollToSection,
                isScrolled: _isScrolled,
              ),
            ),
            if (_showBackToTop)
              Positioned(
                bottom: 45,
                right: 24,
                child: FloatingActionButton.small(
                  onPressed: () => scrollToSection(0),
                  backgroundColor: AppColors.floatingButtonBackground,
                  child: const Icon(
                    Icons.arrow_upward,
                    color: AppColors.floatingButtonIcon,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
