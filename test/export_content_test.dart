// One-off: exports the bundled portfolio content to /tmp/portfolio_content.json for seeding Firestore.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:medbh_portfolio/constants/app_data.dart';
import 'package:medbh_portfolio/models/project_model.dart';

Map<String, dynamic> _project(ProjectModel p, int order) => {
      'name': p.name,
      'description': p.description,
      'appIcon': p.appIcon,
      'playStoreUrl': p.playStoreUrl,
      'appStoreUrl': p.appStoreUrl,
      'webUrl': p.webUrl,
      'githubUrl': p.githubUrl,
      'technologies': p.technologies,
      'screenshots': p.screenshots ?? [],
      'type': p.projectType.name,
      'highlights': p.highlights,
      'order': order,
    };

void main() {
  test('export content', () {
    final projects = [
      for (final (i, p) in AppData.mobileProjects.indexed) _project(p, i),
      for (final (i, p) in AppData.webDesktopProjects.indexed) _project(p, 100 + i),
    ];
    final data = {
      'projects': projects,
      'experiences': [
        for (final (i, e) in AppData.experiences.indexed)
          {'role': e.role, 'company': e.company, 'period': e.period, 'location': e.location, 'order': i},
      ],
      'education': [
        for (final (i, e) in AppData.education.indexed)
          {'degree': e.degree, 'institution': e.institution, 'period': e.period, 'order': i},
      ],
      'certifications': [
        for (final (i, c) in AppData.certifications.indexed) {'name': c.name, 'date': c.date, 'url': c.url, 'order': i},
      ],
      'reviews': [
        for (final (i, r) in AppData.reviews.indexed)
          {
            'name': r.name, 'role': r.role, 'company': r.company, 'text': r.text,
            'initials': r.initials, 'source': r.source, 'sourceUrl': r.sourceUrl, 'order': i,
          },
      ],
    };
    File('/tmp/portfolio_content.json').writeAsStringSync(const JsonEncoder.withIndent('  ').convert(data));
  });
}
