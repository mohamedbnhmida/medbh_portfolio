import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medbh_portfolio/constants/app_colors.dart';
import 'package:medbh_portfolio/services/content_store.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens the CV uploaded from the dashboard; offers English/Français when both exist.
class DownloadCVButton extends StatelessWidget {
  const DownloadCVButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final store = ContentStore.instance;
    final cvs = {
      'English': store.cvEnUrl,
      if (store.cvFrUrl.isNotEmpty) 'Français': store.cvFrUrl,
    };

    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(
          Color.alphaBlend(AppColors.cardBackground, AppColors.primary),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: AppColors.borderAccent),
          ),
        ),
      ),
      menuChildren: [
        for (final e in cvs.entries)
          MenuItemButton(
            onPressed: () => launchUrl(Uri.parse(e.value)),
            leadingIcon: Image.asset(
              'assets/pdf.png',
              height: 18,
              width: 18,
              color: Colors.white,
            ),
            child: Text(
              e.key,
              style: GoogleFonts.orbitron(color: Colors.white),
            ),
          ),
      ],
      builder: (context, menu, _) => OutlinedButton.icon(
        onPressed: () => cvs.length == 1
            ? launchUrl(Uri.parse(cvs.values.first))
            : (menu.isOpen ? menu.close() : menu.open()),
        icon: Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: Image.asset(
            'assets/pdf.png',
            height: 22,
            width: 22,
            color: Colors.white,
          ),
        ),
        label: Text(
          'Download CV',
          style: GoogleFonts.orbitron(
            fontSize: isMobile ? 15 : 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
