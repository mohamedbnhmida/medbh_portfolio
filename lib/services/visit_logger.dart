import 'dart:convert';
import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:web/web.dart' as web;

import 'worker_api.dart';

/// TEST ONLY: records one document per visit in Firestore `visits` (readable only in the
/// Firebase console) to check that location / device / OS / IP detection is correct.
/// Remove this file and its call in main.dart when testing is done.
class VisitLogger {
  static Future<void> log({required bool optedOut}) async {
    if (optedOut) return;
    try {
      final nav = web.window.navigator;
      final ua = nav.userAgent;
      final res = await http
          .post(Uri.parse('${WorkerApi.baseUrl}/visitor'))
          .timeout(const Duration(seconds: 8));
      final net = res.statusCode == 200
          ? jsonDecode(res.body) as Map<String, dynamic>
          : <String, dynamic>{};

      await FirebaseFirestore.instance.collection('visits').add({
        'at': FieldValue.serverTimestamp(),
        'ip': net['ip'] ?? '',
        'country': net['country'] ?? '',
        'region': net['region'] ?? '',
        'city': net['city'] ?? '',
        'timezone': net['timezone'] ?? '',
        'device': _device(ua),
        'os': _os(ua),
        'browser': _browser(ua),
        'userAgent': ua.length > 590 ? ua.substring(0, 590) : ua,
        'language': nav.language,
        'screen': '${web.window.screen.width}x${web.window.screen.height}',
        'referrer': web.document.referrer,
        'source': _source(
          ua,
          web.document.referrer,
          web.window.location.search,
        ),
        'page': web.window.location.href,
      });
    } catch (e) {
      // never break the site; visible in the browser console while testing
      web.console.warn('[visits] not recorded: $e'.toJS);
    }
  }

  /// Where the visitor came from: an explicit link tag (?ref= / utm_source=) wins, then the
  /// in-app browser named in the user agent, then the referrer's domain, else "direct".
  static String _source(String ua, String referrer, String query) {
    final params = Uri.splitQueryString(
      query.startsWith('?') ? query.substring(1) : query,
    );
    final tag = params['ref'] ?? params['utm_source'];
    if (tag != null && tag.isNotEmpty)
      return tag.toLowerCase().substring(0, tag.length.clamp(0, 40));
    for (final (pattern, name) in [
      (r'LinkedInApp', 'linkedin'),
      (r'FBAN|FBAV|FB_IAB', 'facebook'),
      (r'Instagram', 'instagram'),
      (r'WhatsApp', 'whatsapp'),
      (r'Telegram', 'telegram'),
    ]) {
      if (RegExp(pattern).hasMatch(ua)) return name;
    }
    final host = Uri.tryParse(referrer)?.host ?? '';
    for (final (domain, name) in [
      ('linkedin.com', 'linkedin'),
      ('lnkd.in', 'linkedin'),
      ('facebook.com', 'facebook'),
      ('instagram.com', 'instagram'),
      ('t.co', 'twitter'),
      ('x.com', 'twitter'),
      ('google.', 'google'),
      ('bing.com', 'bing'),
      ('github.com', 'github'),
      ('malt.', 'malt'),
    ]) {
      if (host.contains(domain)) return name;
    }
    return host.isEmpty ? 'direct' : host;
  }

  static String _device(String ua) {
    if (RegExp(
      r'iPad|Tablet|(Android(?!.*Mobile))',
      caseSensitive: false,
    ).hasMatch(ua))
      return 'tablet';
    if (RegExp(r'Mobi|iPhone|Android', caseSensitive: false).hasMatch(ua))
      return 'mobile';
    return 'desktop';
  }

  static String _os(String ua) {
    final ios = RegExp(
      r'(?:iPhone|iPad|iPod).*? OS (\d+[_\d]*)',
    ).firstMatch(ua);
    if (ios != null) return 'iOS ${ios.group(1)!.replaceAll('_', '.')}';
    final android = RegExp(r'Android ([\d.]+)').firstMatch(ua);
    if (android != null) return 'Android ${android.group(1)}';
    if (ua.contains('Windows NT 10')) return 'Windows 10/11';
    if (ua.contains('Windows')) return 'Windows';
    final mac = RegExp(r'Mac OS X ([\d_]+)').firstMatch(ua);
    if (mac != null) return 'macOS ${mac.group(1)!.replaceAll('_', '.')}';
    if (ua.contains('CrOS')) return 'ChromeOS';
    if (ua.contains('Linux')) return 'Linux';
    return 'Unknown';
  }

  static String _browser(String ua) {
    for (final (pattern, name) in [
      (r'Edg/([\d]+)', 'Edge'),
      (r'OPR/([\d]+)', 'Opera'),
      (r'SamsungBrowser/([\d]+)', 'Samsung Internet'),
      (r'CriOS/([\d]+)', 'Chrome'),
      (r'FxiOS/([\d]+)', 'Firefox'),
      (r'Firefox/([\d]+)', 'Firefox'),
      (r'Chrome/([\d]+)', 'Chrome'),
      (r'Version/([\d]+).*Safari', 'Safari'),
    ]) {
      final m = RegExp(pattern).firstMatch(ua);
      if (m != null) return '$name ${m.group(1)}';
    }
    return 'Unknown';
  }
}
