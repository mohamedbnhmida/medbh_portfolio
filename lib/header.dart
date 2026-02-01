import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:medbh_portfolio/floatinf_social_media.dart';
import 'header_button.dart';

class ResponsiveHeader extends StatelessWidget {
  final Function(int) onNavTap;

  const ResponsiveHeader({super.key, required this.onNavTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 900) {
          return MobileHeader(onNavTap: onNavTap);
        } else {
          return DesktopHeader(onNavTap: onNavTap);
        }
      },
    );
  }
}

class DesktopHeader extends StatelessWidget {
  final Function(int) onNavTap;

  const DesktopHeader({super.key, required this.onNavTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
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
            'MyPortfolio',
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

  const MobileHeader({super.key, required this.onNavTap});

  @override
  _MobileHeaderState createState() => _MobileHeaderState();
}

class _MobileHeaderState extends State<MobileHeader> {
  bool _isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _isMenuOpen
            ? const Color(0xFF0A0F1A) // Solid dark background when open
            : Colors.black.withOpacity(0.3),
        border: _isMenuOpen
            ? const Border(bottom: BorderSide(color: Colors.white12))
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
                      setState(() => _isMenuOpen = false); // Close menu on tap
                    }),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
