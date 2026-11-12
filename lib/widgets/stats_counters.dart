import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medbh_portfolio/constants/app_colors.dart';
import 'package:medbh_portfolio/services/content_store.dart';

/// Count-up numbers under the hero: years (from experience periods), projects, clients (from profile settings).
/// Loops: count up for 1.5s, hold, repeat every 5s.
class StatsCounters extends StatefulWidget {
  const StatsCounters({super.key});

  @override
  State<StatsCounters> createState() => _StatsCountersState();
}

class _StatsCountersState extends State<StatsCounters>
    with SingleTickerProviderStateMixin {
  late final _loop = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  )..repeat();
  late final _progress = CurvedAnimation(
    parent: _loop,
    curve: const Interval(0, 0.3, curve: Curves.easeOut),
  );

  @override
  void dispose() {
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = ContentStore.instance;
    final isMobile = MediaQuery.of(context).size.width < 600;
    final stats = [
      (store.yearsOfExperience, 'Years'),
      (store.projectsCount, 'Projects'),
      (store.clientsCount, 'Clients'),
    ];
    // One line, equal-size cards (max 600 wide in total).
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (value, label) in stats)
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: isMobile ? 5 : 12),
                  padding: EdgeInsets.symmetric(
                    vertical: isMobile ? 14 : 22,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderAccent),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _progress,
                        builder: (_, _) => Text(
                          '${(_progress.value * value).round()}+',
                          style: GoogleFonts.orbitron(
                            fontFeatures: const [FontFeature.tabularFigures()],
                            fontSize: isMobile ? 26 : 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        label,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.orbitron(
                          fontSize: isMobile ? 10 : 13,
                          color: Colors.white70,
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
