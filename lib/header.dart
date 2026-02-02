import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:medbh_portfolio/constants/app_colors.dart';
import 'package:medbh_portfolio/floatinf_social_media.dart';
import 'header_button.dart';

class ResponsiveHeader extends StatelessWidget {
  final Function(int) onNavTap;
  final bool isScrolled;

  const ResponsiveHeader({
    super.key,
    required this.onNavTap,
    this.isScrolled = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 900) {
          return MobileHeader(onNavTap: onNavTap, isScrolled: isScrolled);
        } else {
          return DesktopHeader(onNavTap: onNavTap, isScrolled: isScrolled);
        }
      },
    );
  }
}

class DesktopHeader extends StatelessWidget {
  final Function(int) onNavTap;
  final bool isScrolled;

  const DesktopHeader({
    super.key,
    required this.onNavTap,
    this.isScrolled = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: isScrolled ? 10 : 0,
          sigmaY: isScrolled ? 10 : 0,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          decoration: BoxDecoration(
            color: isScrolled
                ? AppColors.primary.withOpacity(0.7)
                : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: isScrolled ? Colors.white10 : Colors.transparent,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipOval(
                  child: Image.asset(
                    'assets/icon.png',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                'Mohamed Ben Hmida',
                style: GoogleFonts.orbitron(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Row(children: headerButtons(context, onNavTap)),
            ],
          ),
        ),
      ),
    );
  }
}

List<Widget> headerButtons(BuildContext context, Function(int) onNavTap) => [
  HeaderButton(text: 'Home', onTap: () => onNavTap(0)),
  HeaderButton(text: 'About', onTap: () => onNavTap(1)),
  HeaderButton(text: 'Tech', onTap: () => onNavTap(2)),
  HeaderButton(text: 'Projects', onTap: () => onNavTap(3)),
  HeaderButton(text: 'Contact', onTap: () => onNavTap(4)),
  const FloatingSocialMediaBar(),
];

class MobileHeader extends StatefulWidget {
  final Function(int) onNavTap;
  final bool isScrolled;

  const MobileHeader({
    super.key,
    required this.onNavTap,
    this.isScrolled = false,
  });

  @override
  _MobileHeaderState createState() => _MobileHeaderState();
}

class _MobileHeaderState extends State<MobileHeader> {
  bool _isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: (widget.isScrolled || _isMenuOpen) ? 10 : 0,
          sigmaY: (widget.isScrolled || _isMenuOpen) ? 10 : 0,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          decoration: BoxDecoration(
            color: (widget.isScrolled || _isMenuOpen)
                ? AppColors.primary.withOpacity(0.8)
                : Colors.transparent,
            border: (widget.isScrolled || _isMenuOpen)
                ? const Border(bottom: BorderSide(color: Colors.white10))
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/icon.png',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(
                          'MyPortfolio',
                          style: GoogleFonts.orbitron(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        _isMenuOpen ? Icons.close : Icons.menu,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isMenuOpen = !_isMenuOpen;
                        });
                      },
                    ),
                  ],
                ),
                if (_isMenuOpen)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.center, // Center all items
                      children: [
                        ...headerButtons(context, (index) {
                          widget.onNavTap(index);
                          setState(
                            () => _isMenuOpen = false,
                          ); // Close menu on tap
                        }),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
