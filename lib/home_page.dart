import 'package:flutter/material.dart';
import 'package:medbh_portfolio/animated_background.dart';
import 'package:medbh_portfolio/animated_shapes.dart';
import 'package:medbh_portfolio/constants/app_colors.dart';
import 'package:medbh_portfolio/description_section.dart';
import 'package:medbh_portfolio/explore_button.dart';
import 'package:medbh_portfolio/floating_chatbot_button.dart';
import 'package:medbh_portfolio/header.dart';
import 'package:medbh_portfolio/logo_tagline.dart';
import 'package:medbh_portfolio/widgets/contact_section.dart';
import 'package:medbh_portfolio/widgets/profile_image.dart';
import 'package:medbh_portfolio/widgets/projects_section.dart';
import 'package:medbh_portfolio/widgets/technologies_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _technologiesKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  bool _showBackToTop = false;
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 1),
    )..repeat();

    _scrollController.addListener(() {
      // Back to top button logic
      if (_scrollController.offset > 300 && !_showBackToTop) {
        setState(() => _showBackToTop = true);
      } else if (_scrollController.offset <= 300 && _showBackToTop) {
        setState(() => _showBackToTop = false);
      }

      // Sticky header scroll state logic
      if (_scrollController.offset > 20 && !_isScrolled) {
        setState(() => _isScrolled = true);
      } else if (_scrollController.offset <= 20 && _isScrolled) {
        setState(() => _isScrolled = false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
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
      // About
      _scrollController.animateTo(
        300,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else if (index == 2) {
      // Technologies
      Scrollable.ensureVisible(
        _technologiesKey.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else if (index == 3) {
      // Projects
      Scrollable.ensureVisible(
        _projectsKey.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else if (index == 4) {
      // Contact
      Scrollable.ensureVisible(
        _contactKey.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1A),
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedColorCyclingGradient(controller: _controller),
            AnimatedShapes(controller: _controller),
            SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width < 600 ? 70 : 100,
                  ), // Space for sticky header
                  // Hero Section with Profile Image on the RIGHT
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 800) {
                        return const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LogoAndTagline(),
                                  SizedBox(height: 40),
                                  DescriptionSection(), // Moved here
                                ],
                              ),
                            ),
                            SizedBox(width: 40),
                            ProfileImage(), // Moved to the right
                          ],
                        );
                      } else {
                        return const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ProfileImage(),
                            SizedBox(height: 20),
                            LogoAndTagline(),
                            SizedBox(height: 30),
                            DescriptionSection(), // Moved here as well for mobile flow
                          ],
                        );
                      }
                    },
                  ),

                  // const SizedBox(height: 40), <-- Removed spacer
                  // const DescriptionSection(), <-- Removed from here
                  const SizedBox(height: 40),
                  ExploreButton(onTap: () => scrollToSection(3)),

                  const SizedBox(height: 80),
                  SizedBox(
                    key: _technologiesKey,
                    child: const TechnologiesSection(),
                  ),

                  const SizedBox(height: 80),
                  SizedBox(key: _projectsKey, child: const ProjectsSection()),

                  const SizedBox(height: 80),
                  SizedBox(key: _contactKey, child: const ContactSection()),

                  const SizedBox(height: 60),
                ],
              ),
            ),
            // Header at the top of the Stack (on top of content)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ResponsiveHeader(
                onNavTap: scrollToSection,
                isScrolled: _isScrolled,
              ),
            ),
            // Floating scroll-to-top button at leading (left) side
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
      // floatingActionButton: FloatingChatBotButton(),
    );
  }
}
