import 'dart:js_interop';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:web/web.dart' as web;

import '../firebase_options.dart';
import 'visit_logger.dart';

/// Page views via Google Analytics for Firebase (visits, country/city, device,
/// browser, referrer are reported automatically in the Firebase console).
///
/// Exclude your own browser: open the site once with `?notrack` (stored in
/// localStorage); open it with `?track` to undo.
class AnalyticsService {
  static const _optOutKey = 'portfolio_notrack';

  static Future<void> init() async {
    try {
      final storage = web.window.localStorage;
      final query = web.window.location.search;
      if (query.contains('notrack')) {
        storage.setItem(_optOutKey, '1');
      } else if (query.contains('track')) {
        storage.removeItem(_optOutKey);
      }
      final optedOut = storage.getItem(_optOutKey) == '1';

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      final analytics = FirebaseAnalytics.instance;
      await analytics.setAnalyticsCollectionEnabled(!optedOut);
      if (!optedOut) await analytics.logScreenView(screenName: 'home');
      await VisitLogger.log(
        optedOut: optedOut,
      ); // TEST: remove after verifying visit data
    } catch (e) {
      // Analytics must never break the portfolio; log so failures are visible in the console.
      web.console.warn('[analytics] init failed: $e'.toJS);
    }
  }
}
