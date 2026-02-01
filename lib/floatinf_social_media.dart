import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medbh_portfolio/constants/app_strings.dart';
import 'package:url_launcher/url_launcher.dart';

class FloatingSocialMediaBar extends StatelessWidget {
  const FloatingSocialMediaBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: const [
        SocialIconHover(
          icon: FontAwesomeIcons.github,
          url: AppStrings.githubUrl,
        ),
        SocialIconHover(
          icon: FontAwesomeIcons.linkedinIn,
          url: AppStrings.linkedinUrl,
        ),
        SocialIconHover(
          icon: FontAwesomeIcons.whatsapp,
          url: "https://wa.me/${AppStrings.whatsappNumber}",
        ),
      ],
    );
  }
}

class SocialIconHover extends StatefulWidget {
  final IconData icon;
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
            child: Icon(
              widget.icon,
              color: isHovering ? Colors.white : Colors.black.withOpacity(0.7),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
