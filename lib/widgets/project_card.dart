import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medbh_portfolio/constants/app_colors.dart';
import 'package:medbh_portfolio/models/project_model.dart';
import 'package:medbh_portfolio/widgets/app_image.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectCard extends StatefulWidget {
  final ProjectModel project;

  /// Sibling projects, so the details popup can switch prev/next.
  final List<ProjectModel> projects;

  const ProjectCard({
    super.key,
    required this.project,
    this.projects = const [],
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  int _currentImageIndex = 0;
  Timer? _timer;

  final List<String> _placeholderImages = ['assets/icon.png'];

  ImageProvider _getImageProvider(String path) {
    return appImageProvider(path);
  }

  List<String> get _images {
    if (widget.project.screenshots != null &&
        widget.project.screenshots!.isNotEmpty) {
      return widget.project.screenshots!;
    }
    if (widget.project.appIcon != null) {
      return [widget.project.appIcon!];
    }
    return _placeholderImages;
  }

  bool get _isUsingFallback {
    return (widget.project.screenshots == null ||
        widget.project.screenshots!.isEmpty);
  }

  bool get _isWebDesktop =>
      widget.project.projectType == ProjectType.webDesktop;

  @override
  void initState() {
    super.initState();
    if (_images.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 14), (timer) {
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

  void _openCarousel(
    BuildContext context, {
    int initialIndex = 0,
    List<String>? images,
  }) {
    if (images == null && _images.length <= 1 && _isUsingFallback) return;
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.85),
      builder: (_) => _FullscreenCarousel(
        images: images ?? _images,
        initialIndex: initialIndex,
      ),
    );
  }

  void _openDetails(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (_) => _ProjectBrowser(
        projects: widget.projects.contains(widget.project)
            ? widget.projects
            : [widget.project],
        initialIndex: widget.projects
            .indexOf(widget.project)
            .clamp(0, widget.projects.length),
        onImageTap: (images, index) {
          Navigator.of(context).pop();
          _openCarousel(context, initialIndex: index, images: images);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Tap opens the project details; images inside the details still open the fullscreen carousel.
      onTap: () => _openDetails(context),
      child: Container(
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
                        fit: BoxFit.fill,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(
                              alpha: _isUsingFallback
                                  ? 0.9
                                  : (_isWebDesktop ? 0.5 : 0.7),
                            ),
                            Colors.black.withValues(
                              alpha: _isUsingFallback
                                  ? 0.9
                                  : (_isWebDesktop ? 0.85 : 0.7),
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
                    // Header: Icon (mobile only) + Name
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isMobile = constraints.maxWidth < 400;
                        final iconSize = isMobile ? 45.0 : 60.0;
                        final titleSize = isMobile ? 16.0 : 20.0;

                        if (_isWebDesktop) {
                          return Text(
                            widget.project.name,
                            style: GoogleFonts.orbitron(
                              fontSize: titleSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          );
                        }

                        return Row(
                          children: [
                            if (widget.project.appIcon != null)
                              Container(
                                width: iconSize,
                                height: iconSize,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white24),
                                  image: DecorationImage(
                                    image: _getImageProvider(
                                      widget.project.appIcon!,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            if (widget.project.appIcon != null)
                              const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.project.name,
                                style: GoogleFonts.orbitron(
                                  fontSize: titleSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
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
                                  color: Colors.blueAccent.withValues(
                                    alpha: 0.3,
                                  ),
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

                    // Store / Web Badges
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (widget.project.webUrl != null)
                          InkWell(
                            onTap: () => _launchUrl(widget.project.webUrl!),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blueAccent.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.language,
                                    color: Colors.white70,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Visit Website",
                                    style: GoogleFonts.orbitron(
                                      fontSize: 11,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (widget.project.webUrl != null &&
                            (widget.project.appStoreUrl != null ||
                                widget.project.playStoreUrl != null))
                          const SizedBox(width: 12),
                        if (widget.project.appStoreUrl != null)
                          InkWell(
                            onTap: () =>
                                _launchUrl(widget.project.appStoreUrl!),
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
                            onTap: () =>
                                _launchUrl(widget.project.playStoreUrl!),
                            child: Image.asset(
                              'assets/playstore.png',
                              height: 30,
                            ),
                          ),
                        if (widget.project.githubUrl != null)
                          Tooltip(
                            message: 'Source code on GitHub',
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: InkWell(
                                onTap: () =>
                                    _launchUrl(widget.project.githubUrl!),
                                child: Image.asset(
                                  'assets/github.png',
                                  color: Colors.white,
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                          ),
                        if (widget.project.apkUrl != null)
                          Tooltip(
                            message: 'Download APK',
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: InkWell(
                                onTap: () => _launchUrl(widget.project.apkUrl!),
                                child: const Icon(
                                  Icons.android,
                                  color: Colors.greenAccent,
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    // Paging Indicator
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
      ),
    );
  }
}

class _FullscreenCarousel extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const _FullscreenCarousel({required this.images, required this.initialIndex});

  @override
  State<_FullscreenCarousel> createState() => _FullscreenCarouselState();
}

class _FullscreenCarouselState extends State<_FullscreenCarousel> {
  late int _index;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _pageController = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _go(int delta) {
    final next = (_index + delta).clamp(0, widget.images.length - 1);
    _pageController.animateToPage(
      next,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Full-screen page view
            PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (_, i) => InteractiveViewer(
                child: Center(
                  child: Image(
                    image: appImageProvider(widget.images[i]),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Close button
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ),

            // Left arrow
            if (_index > 0)
              Positioned(
                left: 12,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () => _go(-1),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),

            // Right arrow
            if (_index < widget.images.length - 1)
              Positioned(
                right: 12,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () => _go(1),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),

            // Dot indicators
            if (widget.images.length > 1)
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.images.length, (i) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: _index == i ? 16 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _index == i ? Colors.white : Colors.white38,
                      ),
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Holds which project the details popup shows; arrows outside the popup switch prev/next.
class _ProjectBrowser extends StatefulWidget {
  final List<ProjectModel> projects;
  final int initialIndex;
  final void Function(List<String> images, int index) onImageTap;

  const _ProjectBrowser({
    required this.projects,
    required this.initialIndex,
    required this.onImageTap,
  });

  @override
  State<_ProjectBrowser> createState() => _ProjectBrowserState();
}

class _ProjectBrowserState extends State<_ProjectBrowser> {
  late int _i = widget.initialIndex;

  void _go(int delta) => setState(
    () => _i = (_i + delta + widget.projects.length) % widget.projects.length,
  );

  @override
  Widget build(BuildContext context) {
    final project = widget.projects[_i];
    final images = project.screenshots ?? const <String>[];
    final multi = widget.projects.length > 1;
    return _ProjectDetailsDialog(
      key: ValueKey(_i), // fresh slideshow per project
      project: project,
      images: images,
      onImageTap: (index) => widget.onImageTap(images, index),
      onPrev: multi ? () => _go(-1) : null,
      onNext: multi ? () => _go(1) : null,
    );
  }
}

class _ProjectDetailsDialog extends StatefulWidget {
  final ProjectModel project;
  final List<String> images;
  final ValueChanged<int> onImageTap;
  final VoidCallback? onPrev, onNext;

  const _ProjectDetailsDialog({
    super.key,
    required this.project,
    required this.images,
    required this.onImageTap,
    this.onPrev,
    this.onNext,
  });

  @override
  State<_ProjectDetailsDialog> createState() => _ProjectDetailsDialogState();
}

class _ProjectDetailsDialogState extends State<_ProjectDetailsDialog> {
  final PageController _pageController = PageController();
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.images.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 7), (_) {
        if (!mounted) return;
        _go(1);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _go(int delta) {
    final count = widget.images.length;
    final next = (_index + delta + count) % count;
    _pageController.animateToPage(
      next,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  Widget _linkButton(String label, Widget leading, String url) {
    return InkWell(
      onTap: () => _launchUrl(url),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderAccent),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            leading,
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.orbitron(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  /// Round prev/next button sitting outside the popup.
  Widget _projectArrow(IconData icon, VoidCallback onTap, bool compact) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: compact ? 4 : 12),
      child: Material(
        color: Color.alphaBlend(AppColors.cardBackground, AppColors.primary),
        shape: CircleBorder(side: BorderSide(color: AppColors.borderAccent)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: compact ? 36 : 52,
            height: compact ? 36 : 52,
            child: Icon(icon, color: Colors.white, size: compact ? 20 : 28),
          ),
        ),
      ),
    );
  }

  Widget _buildSlideshow(BorderRadius borderRadius) {
    if (widget.images.isEmpty) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Container(
          color: Colors.black26,
          alignment: Alignment.center,
          child: widget.project.appIcon != null
              ? Image(
                  image: appImageProvider(widget.project.appIcon!),
                  fit: BoxFit.contain,
                )
              : const Icon(
                  Icons.image_outlined,
                  color: Colors.white24,
                  size: 48,
                ),
        ),
      );
    }
    return ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) => GestureDetector(
              onTap: () => widget.onImageTap(i),
              child: Image(
                image: appImageProvider(widget.images[i]),
                fit: BoxFit.contain,
              ),
            ),
          ),
          if (widget.images.length > 1) ...[
            Positioned(
              left: 10,
              top: 0,
              bottom: 0,
              child: Center(
                child: _navButton(Icons.chevron_left, () => _go(-1)),
              ),
            ),
            Positioned(
              right: 10,
              top: 0,
              bottom: 0,
              child: Center(
                child: _navButton(Icons.chevron_right, () => _go(1)),
              ),
            ),
            Positioned(
              bottom: 14,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.images.length, (i) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: _index == i ? 18 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: _index == i ? Colors.white : Colors.white38,
                    ),
                  );
                }),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetails() {
    final project = widget.project;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (project.appIcon != null)
                Container(
                  width: 48,
                  height: 48,
                  margin: const EdgeInsets.only(right: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                    image: DecorationImage(
                      image: appImageProvider(project.appIcon!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Expanded(
                child: Text(
                  project.name,
                  style: GoogleFonts.orbitron(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            project.description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.6,
            ),
          ),
          if (project.highlights.isNotEmpty) ...[
            const SizedBox(height: 22),
            Text(
              "Highlights",
              style: GoogleFonts.orbitron(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            for (final point in project.highlights)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 7),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox(width: 5, height: 5),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text.rich(
                        _emphasizeNumbers(
                          point,
                          const TextStyle(
                            color: Colors.white70,
                            fontSize: 13.5,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
          const SizedBox(height: 12),
          Text(
            "Technologies",
            style: GoogleFonts.orbitron(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: project.technologies
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
          if (project.webUrl != null ||
              project.appStoreUrl != null ||
              project.playStoreUrl != null ||
              project.apkUrl != null ||
              project.githubUrl != null) ...[
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                if (project.webUrl != null)
                  _linkButton(
                    "Visit Website",
                    const Icon(
                      Icons.language,
                      color: Colors.blueAccent,
                      size: 16,
                    ),
                    project.webUrl!,
                  ),
                if (project.appStoreUrl != null)
                  _linkButton(
                    "App Store",
                    Image.asset(
                      'assets/apple.png',
                      height: 16,
                      color: Colors.white,
                    ),
                    project.appStoreUrl!,
                  ),
                if (project.playStoreUrl != null)
                  _linkButton(
                    "Google Play",
                    Image.asset('assets/playstore.png', height: 16),
                    project.playStoreUrl!,
                  ),
                if (project.apkUrl != null)
                  _linkButton(
                    "Download APK",
                    const Icon(
                      Icons.android,
                      color: Colors.greenAccent,
                      size: 16,
                    ),
                    project.apkUrl!,
                  ),
                if (project.githubUrl != null)
                  _linkButton(
                    "GitHub",
                    Image.asset(
                      'assets/github.png',
                      color: Colors.white,
                      width: 16,
                      height: 16,
                    ),
                    project.githubUrl!,
                  ),
              ],
            ),
            if (project.apkQrCode != null) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      project.apkQrCode!,
                      width: 120,
                      height: 120,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Scan to download the APK on your Android phone.",
                      style: GoogleFonts.orbitron(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final maxHeight = (screenSize.height * 0.92).clamp(460.0, 880.0);
    final maxWidth = (screenSize.width * 0.9).clamp(320.0, 1240.0);
    final compact = screenSize.width < 700;
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(
        horizontal: compact ? 4 : 12,
        vertical: 16,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.onPrev != null)
            _projectArrow(Icons.chevron_left, widget.onPrev!, compact),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
                maxHeight: maxHeight,
              ),
              decoration: BoxDecoration(
                color: Color.alphaBlend(
                  AppColors.cardBackground,
                  AppColors.primary,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.borderAccent),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 700;
                        if (isWide) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(flex: 5, child: _buildDetails()),
                              Expanded(
                                flex: 4,
                                child: _buildSlideshow(
                                  const BorderRadius.horizontal(
                                    right: Radius.circular(24),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return Column(
                          children: [
                            SizedBox(
                              height: 260,
                              width: double.infinity,
                              child: _buildSlideshow(
                                const BorderRadius.vertical(
                                  top: Radius.circular(24),
                                ),
                              ),
                            ),
                            Expanded(child: _buildDetails()),
                          ],
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.onNext != null)
            _projectArrow(Icons.chevron_right, widget.onNext!, compact),
        ],
      ),
    );
  }
}

/// Bold accent for figures like "80%", "5M+", "70%" inside a bullet.
TextSpan _emphasizeNumbers(String text, TextStyle style) {
  final spans = <TextSpan>[];
  text.splitMapJoin(
    RegExp(r'\d+(?:[.,]\d+)?\s?(?:%|[MK]\+?|\+)?'),
    onMatch: (m) {
      spans.add(
        TextSpan(
          text: m[0],
          style: style.copyWith(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      return '';
    },
    onNonMatch: (t) {
      spans.add(TextSpan(text: t, style: style));
      return '';
    },
  );
  return TextSpan(children: spans);
}
