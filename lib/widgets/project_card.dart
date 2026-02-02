import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medbh_portfolio/constants/app_colors.dart'; 
import 'package:medbh_portfolio/models/project_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectCard extends StatefulWidget {
  final ProjectModel project;

  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  int _currentImageIndex = 0;
  Timer? _timer;

  // Placeholder images since we don't have real screenshots yet
  final List<String> _placeholderImages = ['assets/icon.png'];

  ImageProvider _getImageProvider(String path) {
    return AssetImage(path);
  }

  List<String> get _images {
    // Return real screenshots if available
    if (widget.project.screenshots != null &&
        widget.project.screenshots!.isNotEmpty) {
      return widget.project.screenshots!;
    }
    // Fallback to app icon if available
    if (widget.project.appIcon != null) {
      return [widget.project.appIcon!];
    }
    // Final fallback
    return _placeholderImages;
  }

  bool get _isUsingFallback {
    return (widget.project.screenshots == null ||
        widget.project.screenshots!.isEmpty);
  }

  @override
  void initState() {
    super.initState();
    // Use the getter for length check
    if (_images.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (mounted) {
          setState(() {
            _currentImageIndex = (_currentImageIndex + 1) % _images.length;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: AppColors.borderAccent),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.0),
        child: Stack(
          children: [
            // Background Slideshow
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 800),
                child: Container(
                  key: ValueKey<int>(_currentImageIndex),
                  decoration: BoxDecoration(
                    color: _isUsingFallback ? Colors.white : Colors.black,
                    image: DecorationImage(
                      image: _getImageProvider(_images[_currentImageIndex]),
                      fit: BoxFit
                          .fill, // Using fill to force full height coverage as requested
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(
                            _isUsingFallback ? 0.9 : 0.7,
                          ),
                          Colors.black.withOpacity(
                            _isUsingFallback ? 0.9 : 0.7,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Icon + Name
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isMobile = constraints.maxWidth < 400;
                      final iconSize = isMobile ? 45.0 : 60.0;
                      final titleSize = isMobile ? 16.0 : 20.0;

                      return Row(
                        children: [
                          Container(
                            width: iconSize,
                            height: iconSize,
                            decoration: BoxDecoration(
                              color:
                                  Colors.white, // White background for the icon
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white24),
                              image: DecorationImage(
                                image: widget.project.appIcon != null
                                    ? _getImageProvider(widget.project.appIcon!)
                                    : const AssetImage('assets/icon.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.project.name,
                                  style: GoogleFonts.orbitron(
                                    fontSize: titleSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Expanded(
                    child: Text(
                      widget.project.description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.5,
                      ),
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tech Stack Chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.project.technologies
                        .take(4)
                        .map(
                          (tech) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.blueAccent.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              tech,
                              style: GoogleFonts.orbitron(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 24),

                  // Store Badges
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (widget.project.appStoreUrl != null)
                        InkWell(
                          onTap: () => _launchUrl(widget.project.appStoreUrl!),
                          child: Image.asset(
                            'assets/apple.png',
                            height: 30,
                            color: Colors.white,
                          ),
                        ),
                      if (widget.project.appStoreUrl != null &&
                          widget.project.playStoreUrl != null)
                        const SizedBox(width: 16),
                      if (widget.project.playStoreUrl != null)
                        InkWell(
                          onTap: () => _launchUrl(widget.project.playStoreUrl!),
                          child: Image.asset(
                            'assets/playstore.png',
                            height: 30,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  // Paging Indicator (Simple Dots)
                  if (_images.length > 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_images.length, (index) {
                        return Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentImageIndex == index
                                ? Colors.white
                                : Colors.white24,
                          ),
                        );
                      }),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
