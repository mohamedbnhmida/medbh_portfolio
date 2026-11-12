import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants/app_data.dart';
import '../constants/app_strings.dart';
import '../models/experience_model.dart';
import '../models/project_model.dart';
import '../models/review_model.dart';
import '../models/technology_model.dart';

/// Portfolio content edited from the dashboard (Firestore). Starts with the bundled
/// [AppData]/[AppStrings] so the page renders instantly and still works offline,
/// then swaps in Firestore content when it arrives.
class ContentStore extends ChangeNotifier {
  ContentStore._();
  static final instance = ContentStore._();

  /// Increments when Firestore content arrives; the home page remounts on change.
  int version = 0;
  Map<String, dynamic> _profile = {};
  List<ProjectModel> mobileProjects = AppData.mobileProjects;
  List<ProjectModel> webDesktopProjects = AppData.webDesktopProjects;
  List<ExperienceModel> experiences = AppData.experiences;
  List<EducationModel> education = AppData.education;
  List<CertificationModel> certifications = AppData.certifications;
  List<ReviewModel> reviews = AppData.reviews;
  List<TechnologyModel> technologies = AppData.technologies;

  String _p(String key, String fallback) {
    final v = _profile[key];
    return v is String && v.isNotEmpty ? v : fallback;
  }

  String get name => _p('name', AppStrings.name);
  String get tagline => _p('tagline', AppStrings.tagline);

  /// Typing animation lines: the name, then each tagline line from the dashboard.
  List<String> get taglines => [
    name,
    ..._p(
      'tagline',
      'Mobile & Web Developer\nSoftware Engineer',
    ).split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty),
  ];
  String get aboutMe => _p('aboutMe', AppStrings.aboutMe);
  String get photoUrl => _p('photoUrl', 'assets/icon.png');
  String get email => _p('email', AppStrings.email);
  String get phone => _p('phone', AppStrings.phone);
  String get whatsappNumber => _p('whatsappNumber', AppStrings.whatsappNumber);
  String get address => _p('address', '');
  String get githubUrl => _p('githubUrl', AppStrings.githubUrl);
  String get linkedinUrl => _p('linkedinUrl', AppStrings.linkedinUrl);
  String get maltUrl => _p('maltUrl', AppStrings.maltUrl);
  String get contactTitle => _p('contactTitle', AppStrings.contactTitle);
  String get contactSubtitle =>
      _p('contactSubtitle', AppStrings.contactSubtitle);
  String get cvEnUrl =>
      _p('cvEnUrl', 'assets/assets/MohamedBenHmida_ATS_CV_EN.pdf');
  String get cvFrUrl => _p('cvFrUrl', '');
  int get clientsCount => int.tryParse(_p('clientsCount', '5')) ?? 5;
  int get projectsCount => int.tryParse(_p('projectsCount', '15')) ?? 15;

  /// Full years since the earliest experience start (e.g. "Sep 2021 - ...").
  int get yearsOfExperience {
    const months = [
      'jan',
      'feb',
      'mar',
      'apr',
      'may',
      'jun',
      'jul',
      'aug',
      'sep',
      'oct',
      'nov',
      'dec',
    ];
    DateTime? first;
    for (final e in experiences) {
      final m = RegExp(
        r'([A-Za-z]{3})[a-z]*\.?\s+(\d{4})',
      ).firstMatch(e.period);
      if (m == null) continue;
      final start = DateTime(
        int.parse(m[2]!),
        months.indexOf(m[1]!.toLowerCase()) + 1,
      );
      if (first == null || start.isBefore(first)) first = start;
    }
    if (first == null) return 0;
    final now = DateTime.now();
    return ((now.year - first.year) * 12 + now.month - first.month) ~/ 12;
  }

  /// Call after Firebase.initializeApp. Failures keep the bundled content.
  Future<void> load() async {
    final db = FirebaseFirestore.instance;
    try {
      final results = await Future.wait([
        db.collection('settings').doc('profile').get(),
        db.collection('projects').where('visible', isEqualTo: true).get(),
        db.collection('experiences').orderBy('order').get(),
        db.collection('education').orderBy('order').get(),
        db.collection('certifications').orderBy('order').get(),
        db.collection('reviews').where('status', isEqualTo: 'approved').get(),
        db.collection('technologies').orderBy('order').get(),
      ]);
      final profile = results[0] as DocumentSnapshot<Map<String, dynamic>>;
      final docs = [
        for (final r in results.skip(1))
          (r as QuerySnapshot<Map<String, dynamic>>).docs
              .map((d) => d.data())
              .toList(),
      ];

      _profile = profile.data() ?? {};
      final projects = docs[0]
        ..sort((a, b) => _int(a['order']).compareTo(_int(b['order'])));
      if (projects.isNotEmpty) {
        mobileProjects = [
          for (final p in projects)
            if (p['type'] != 'webDesktop') _project(p),
        ];
        webDesktopProjects = [
          for (final p in projects)
            if (p['type'] == 'webDesktop') _project(p),
        ];
      }
      if (docs[1].isNotEmpty) {
        experiences = [
          for (final e in docs[1])
            ExperienceModel(
              role: _s(e['role']),
              company: _s(e['company']),
              period: _s(e['period']),
              location: _s(e['location']),
              logo: _opt(e['logo']),
            ),
        ];
      }
      if (docs[2].isNotEmpty) {
        education = [
          for (final e in docs[2])
            EducationModel(
              degree: _s(e['degree']),
              institution: _s(e['institution']),
              period: _s(e['period']),
              logo: _opt(e['logo']),
            ),
        ];
      }
      if (docs[3].isNotEmpty) {
        certifications = [
          for (final c in docs[3])
            CertificationModel(
              name: _s(c['name']),
              date: _s(c['date']),
              url: _opt(c['url']),
              issuer: _s(c['issuer']),
              logo: _opt(c['logo']),
              image: _opt(c['image']),
              credentialId: _opt(c['credentialId']),
              skills: _s(c['skills'])
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList(),
            ),
        ];
      }
      final approved = docs[4]
        ..sort((a, b) => _int(a['order']).compareTo(_int(b['order'])));
      if (approved.isNotEmpty) {
        reviews = [
          for (final r in approved)
            ReviewModel(
              name: _s(r['name']),
              role: _s(r['role']),
              company: _s(r['company']),
              text: _s(r['text']),
              initials: _s(r['initials']),
              source: _s(r['source']),
              sourceUrl: _s(r['sourceUrl']),
              rating: _int(r['rating']),
            ),
        ];
      }
      if (docs[5].isNotEmpty) {
        technologies = [
          for (final t in docs[5])
            TechnologyModel(
              name: _s(t['name']),
              iconUrl: _s(t['icon']),
              color: Colors.blueAccent,
            ),
        ];
      }
      version++;
      notifyListeners();
    } catch (e) {
      debugPrint('Content load failed, using bundled content: $e');
    }
  }

  static String _s(Object? v) => v is String ? v : '';
  static String? _opt(Object? v) => v is String && v.isNotEmpty ? v : null;
  static int _int(Object? v) => v is num ? v.toInt() : 0;
  static List<String> _list(Object? v) => v is List
      ? [
          for (final x in v)
            if (x is String) x,
        ]
      : const [];

  static ProjectModel _project(Map<String, dynamic> p) => ProjectModel(
    name: _s(p['name']),
    description: _s(p['description']),
    appIcon: p['appIcon'] as String?,
    playStoreUrl: p['playStoreUrl'] as String?,
    appStoreUrl: p['appStoreUrl'] as String?,
    webUrl: p['webUrl'] as String?,
    githubUrl: p['githubUrl'] as String?,
    technologies: _list(p['technologies']),
    screenshots: _list(p['screenshots']),
    projectType: p['type'] == 'webDesktop'
        ? ProjectType.webDesktop
        : ProjectType.mobile,
    highlights: _list(p['highlights']),
  );
}
