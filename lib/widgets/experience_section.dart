import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medbh_portfolio/constants/app_colors.dart';
import 'package:medbh_portfolio/models/experience_model.dart';
import 'package:medbh_portfolio/services/content_store.dart';
import 'package:medbh_portfolio/widgets/app_image.dart';
import 'package:url_launcher/url_launcher.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Experience",
          style: GoogleFonts.orbitron(
            fontSize: isMobile ? 22 : 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        for (final exp in ContentStore.instance.experiences)
          _TimelineTile(
            title: exp.role,
            subtitle: "${exp.company} · ${exp.location}",
            period: exp.period,
            logo: exp.logo,
          ),
        const SizedBox(height: 40),
        Text(
          "Education & Certifications",
          style: GoogleFonts.orbitron(
            fontSize: isMobile ? 18 : 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        const _EducationList(),
        const SizedBox(height: 24),
        const _CertificationsGrid(),
      ],
    );
  }
}

/// Timeline row shared by work experience and education.
class _TimelineTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String period;
  final String? logo;
  final double logoPadding;

  const _TimelineTile({
    required this.title,
    required this.subtitle,
    required this.period,
    this.logo,
    this.logoPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Container(width: 2, color: AppColors.borderSubtle),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  children: [
                    if (logo != null) ...[
                      _Logo(logo!, size: 52, padding: logoPadding),
                      const SizedBox(width: 16),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            period,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EducationList extends StatelessWidget {
  const _EducationList();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Education",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        for (final edu in ContentStore.instance.education)
          _TimelineTile(
            title: edu.degree,
            subtitle: edu.institution,
            period: edu.period,
            logo: edu.logo,
            // School logos are drawn edge to edge; pad so the rounded tile doesn't crop them.
            logoPadding: 6,
          ),
      ],
    );
  }
}

/// Rounded company / school / issuer logo on a white tile (most logos assume a light background).
class _Logo extends StatelessWidget {
  final String path;
  final double size;
  final double padding;
  const _Logo(this.path, {required this.size, this.padding = 0});

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    padding: EdgeInsets.all(padding),
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(size / 4),
    ),
    child: Image(image: appImageProvider(path), fit: BoxFit.contain),
  );
}

/// One row of certification cards (3 visible on desktop) that slides and snaps one card at a time.
class _CertificationsGrid extends StatefulWidget {
  const _CertificationsGrid();

  @override
  State<_CertificationsGrid> createState() => _CertificationsGridState();
}

class _CertificationsGridState extends State<_CertificationsGrid> {
  static const _gap = 20.0;
  final _controller = ScrollController();
  double _extent = 1;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final i = (_controller.offset / _extent).round();
      if (i != _index) setState(() => _index = i);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _go(int index, int last) => _controller.animateTo(
    index.clamp(0, last) * _extent,
    duration: const Duration(milliseconds: 350),
    curve: Curves.easeOutCubic,
  );

  @override
  Widget build(BuildContext context) {
    final certs = ContentStore.instance.certifications;
    final width = MediaQuery.of(context).size.width;
    final perPage = width < 600 ? 1 : (width < 1000 ? 2 : 3);
    final last = (certs.length - perPage).clamp(0, certs.length);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Certifications",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth =
                (constraints.maxWidth - _gap * (perPage - 1)) / perPage;
            _extent = cardWidth + _gap;
            return SizedBox(
              // Extra room so the hover lift and glow aren't clipped.
              height: 330 + 30,
              child: ListView.builder(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                physics: _SnapPhysics(_extent),
                itemExtent: _extent,
                itemCount: certs.length,
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 20,
                    right: _gap,
                  ),
                  child: _CertificationCard(cert: certs[i]),
                ),
              ),
            );
          },
        ),
        if (last > 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _PagerArrow(
                icon: Icons.chevron_left_rounded,
                onTap: _index > 0 ? () => _go(_index - 1, last) : null,
              ),
              const SizedBox(width: 16),
              for (var i = 0; i <= last; i++)
                GestureDetector(
                  onTap: () => _go(i, last),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == _index ? 28 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _index ? Colors.blueAccent : Colors.white24,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              const SizedBox(width: 16),
              _PagerArrow(
                icon: Icons.chevron_right_rounded,
                onTap: _index < last ? () => _go(_index + 1, last) : null,
              ),
            ],
          ),
      ],
    );
  }
}

/// Like PageScrollPhysics, but snaps to multiples of [extent] instead of the viewport width.
class _SnapPhysics extends ScrollPhysics {
  final double extent;
  const _SnapPhysics(this.extent, {super.parent});

  @override
  _SnapPhysics applyTo(ScrollPhysics? ancestor) =>
      _SnapPhysics(extent, parent: buildParent(ancestor));

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    if ((velocity <= 0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final tolerance = toleranceFor(position);
    var page = position.pixels / extent;
    if (velocity < -tolerance.velocity) page -= 0.5;
    if (velocity > tolerance.velocity) page += 0.5;
    final target = (page.round() * extent).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    if ((target - position.pixels).abs() < tolerance.distance) return null;
    return ScrollSpringSimulation(
      spring,
      position.pixels,
      target,
      velocity,
      tolerance: tolerance,
    );
  }

  @override
  bool get allowImplicitScrolling => false;
}

class _PagerArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _PagerArrow({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onTap,
    icon: Icon(icon),
    iconSize: 26,
    style: IconButton.styleFrom(
      fixedSize: const Size(48, 48),
      foregroundColor: Colors.white,
      disabledForegroundColor: Colors.white24,
      backgroundColor: AppColors.cardBackground,
      side: BorderSide(color: AppColors.borderAccent),
    ),
  );
}

class _CertificationCard extends StatefulWidget {
  final CertificationModel cert;
  const _CertificationCard({required this.cert});

  @override
  State<_CertificationCard> createState() => _CertificationCardState();
}

class _CertificationCardState extends State<_CertificationCard> {
  bool _hover = false;

  CertificationModel get cert => widget.cert;

  String get _subtitle =>
      [cert.issuer, cert.date].where((s) => s.isNotEmpty).join(" · ");

  void _open(BuildContext context) {
    if (cert.image != null) {
      showDialog(
        context: context,
        barrierColor: Colors.black87,
        builder: (_) => _CertificatePreview(cert: cert, subtitle: _subtitle),
      );
    } else if (cert.url != null) {
      launchUrl(Uri.parse(cert.url!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final tappable = cert.url != null || cert.image != null;
    final hover = _hover && tappable;
    return MouseRegion(
      cursor: tappable ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: tappable ? () => _open(context) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 330,
          transform: Matrix4.translationValues(0, hover ? -6 : 0, 0),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: hover ? Colors.blueAccent : AppColors.borderSubtle,
              width: hover ? 1.5 : 1,
            ),
            boxShadow: [
              if (hover)
                BoxShadow(
                  color: Colors.blueAccent.withValues(alpha: 0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (cert.image != null)
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Image(
                          image: appImageProvider(cert.image!),
                          fit: BoxFit.contain,
                        ),
                      )
                    else
                      DecoratedBox(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF1E3A8A), Color(0xFF0F172A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: cert.logo != null
                              ? _Logo(cert.logo!, size: 64)
                              : const Icon(
                                  Icons.workspace_premium_outlined,
                                  color: Colors.white70,
                                  size: 48,
                                ),
                        ),
                      ),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: hover ? 1 : 0,
                      child: ColoredBox(
                        color: Colors.blueAccent.withValues(alpha: 0.18),
                        child: Center(
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 200),
                            scale: hover ? 1 : 0.6,
                            child: Container(
                              width: 52,
                              height: 52,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                cert.image != null
                                    ? Icons.zoom_in_rounded
                                    : Icons.open_in_new_rounded,
                                color: Colors.blueAccent,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: hover
                    ? Colors.blueAccent.withValues(alpha: 0.5)
                    : AppColors.borderSubtle,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    cert.logo != null
                        ? _Logo(cert.logo!, size: 44)
                        : Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: const Icon(
                              Icons.workspace_premium_outlined,
                              color: Colors.blueAccent,
                            ),
                          ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cert.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
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

class _CertificatePreview extends StatelessWidget {
  final CertificationModel cert;
  final String subtitle;
  const _CertificatePreview({required this.cert, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF111827),
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.borderAccent),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.cyanAccent],
                ),
              ),
            ),
            Flexible(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: InteractiveViewer(
                      child: Image(image: appImageProvider(cert.image!)),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                      ),
                      tooltip: "Close",
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cert.name,
                          style: GoogleFonts.orbitron(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          [
                            subtitle,
                            if (cert.credentialId != null)
                              "ID: ${cert.credentialId}",
                          ].where((s) => s.isNotEmpty).join(" · "),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (cert.url != null) ...[
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      onPressed: () => launchUrl(Uri.parse(cert.url!)),
                      icon: const Icon(Icons.open_in_new_rounded, size: 16),
                      label: const Text("Show credential"),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
