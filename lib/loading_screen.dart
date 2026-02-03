import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medbh_portfolio/animated_background.dart';
import 'package:medbh_portfolio/home_page.dart';
import 'package:medbh_portfolio/widgets/random_curves.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  bool _isInitialized = false;
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Wait for fonts to be ready with a timeout
      await GoogleFonts.pendingFonts().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint('Font loading timed out, continuing...');
          return [];
        },
      );
    } catch (e) {
      debugPrint('Error loading fonts: $e');
    }

    // Preload key assets
    if (mounted) {
      final assetsToPreload = [
        'assets/icon.png',
        'assets/flutter.png',
        'assets/firebase.png',
        'assets/apple.png',
        'assets/playstore.png',
      ];

      for (var asset in assetsToPreload) {
        precacheImage(AssetImage(asset), context);
      }
    }

    // Ensure the loading animation is visible for a minimum amount of time
    // to give a professional "initializing" feel.
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized ? HomePage() : _buildLoadingScreen();
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          AnimatedColorCyclingGradient(controller: _bgController),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const RandomCurves(),
                const SizedBox(height: 30),
                AnimatedBuilder(
                  animation: _bgController,
                  builder: (context, child) {
                    final dotCount =
                        (DateTime.now().millisecondsSinceEpoch / 500).floor() %
                        4;
                    final dots = '.' * dotCount;
                    return Text(
                      'Loading$dots',
                      style: GoogleFonts.orbitron(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
