import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadCVButton extends StatelessWidget {
  const DownloadCVButton({super.key});

  Future<void> _downloadCV() async {
    final Uri url = Uri.parse('assets/MohamedBenHmida_ATS_CV_EN.pdf');
    if (!await launchUrl(url)) {
      // In web, assets can usually be opened via the relative path
      // If it fails, we can try to show an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return OutlinedButton.icon(
      onPressed: _downloadCV,
      icon: Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: Image.asset(
          'assets/pdf.png',
          height: 22,
          width: 22,
          color: Colors.white, // Optional: if you want to tint it white
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
        padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
