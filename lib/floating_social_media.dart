import 'package:flutter/material.dart';
import 'package:medbh_portfolio/services/content_store.dart';
import 'package:url_launcher/url_launcher.dart';

class FloatingSocialMediaBar extends StatelessWidget {
  const FloatingSocialMediaBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SocialIconHover(
          icon: 'assets/github.png',
          url: ContentStore.instance.githubUrl,
        ),
        SocialIconHover(
          icon: 'assets/linkedin.png',
          url: ContentStore.instance.linkedinUrl,
        ),
        SocialIconHover(
          icon: 'assets/whatsapp.png',
          url:
              "https://wa.me/${ContentStore.instance.whatsappNumber}?text=${Uri.encodeComponent("Hello, I am interested in your portfolio!")}",
        ),
      ],
    );
  }
}

class SocialIconHover extends StatefulWidget {
  final String icon; // png asset, tinted
  final String url;

  const SocialIconHover({required this.icon, required this.url, super.key});

  @override
  State<SocialIconHover> createState() => _SocialIconHoverState();
}

class _SocialIconHoverState extends State<SocialIconHover> {
  bool isHovering = false;

  Future<void> _launchUrl() async {
    final Uri uri = Uri.parse(widget.url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: GestureDetector(
        onTap: _launchUrl,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isHovering ? Colors.blueAccent : Colors.white,
              shape: BoxShape.circle,
              boxShadow: isHovering
                  ? [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: Image.asset(
              widget.icon,
              color: isHovering ? Colors.white : Colors.black.withOpacity(0.7),
              width: 20,
              height: 20,
            ),
          ),
        ),
      ),
    );
  }
}
