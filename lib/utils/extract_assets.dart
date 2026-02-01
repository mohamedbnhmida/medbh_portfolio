import 'dart:io';
import 'package:http/http.dart' as http;

/// Run this script from the project root:
/// dart lib/utils/extract_assets.dart

void main() async {
  final file = File('lib/constants/app_data.dart');
  if (!file.existsSync()) {
    print(
      'Error: lib/constants/app_data.dart not found. Run from project root.',
    );
    return;
  }

  String content = file.readAsStringSync();

  // Create assets directory if not exists
  final assetsRootDir = Directory('assets/projects');
  if (!assetsRootDir.existsSync()) {
    assetsRootDir.createSync(recursive: true);
  }

  // Regex to find ProjectModel blocks.
  final projectBlockRegExp = RegExp(
    r'ProjectModel\s*\(([\s\S]*?)\),',
    multiLine: true,
  );

  final matches = projectBlockRegExp.allMatches(content);
  final client = http.Client();

  StringBuffer newCodeBuffer = StringBuffer();
  newCodeBuffer.writeln('  static const List<ProjectModel> projects = [');

  print('Found ${matches.length} projects. Scanning and Downloading...');

  for (final match in matches) {
    final block = match.group(1)!;

    // Extract existing fields
    final name = _extractField(block, 'name');
    final description = _extractField(block, 'description');
    final appStoreUrl = _extractField(block, 'appStoreUrl');
    final playStoreUrl = _extractField(block, 'playStoreUrl');

    // Extract technologies list manually since it might be multi-line
    final techMatch = RegExp(
      r'technologies:\s*\[([\s\S]*?)\]',
    ).firstMatch(block);
    final technologies = techMatch != null ? techMatch.group(1)!.trim() : '';

    if (name == null) continue;

    // Sanitize name for filename prefix
    final folderName = name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');
    // We use the flat directory now
    final projectDir = assetsRootDir;

    print('  Processing "$name" -> ${projectDir.path} (prefix: $folderName)');

    String? foundIconUrl;
    List<String> foundScreenshotUrls = [];

    // 1. Scrape URLs
    if (appStoreUrl != null) {
      final data = await _scrapeStore(client, appStoreUrl, isApple: true);
      foundIconUrl = data['icon'];
      foundScreenshotUrls.addAll(data['screenshots'] ?? []);
    }

    if (playStoreUrl != null &&
        (foundIconUrl == null || foundScreenshotUrls.isEmpty)) {
      final data = await _scrapeStore(client, playStoreUrl, isApple: false);
      foundIconUrl ??= data['icon'];
      if (foundScreenshotUrls.isEmpty) {
        foundScreenshotUrls.addAll(data['screenshots'] ?? []);
      }
    }

    // 2. Download Images (Flattened)
    String? localIconPath;
    if (foundIconUrl != null) {
      // Determine extension (default png if unknown)
      String ext = _getExtension(foundIconUrl);
      final fileName = '${folderName}_icon$ext';
      final filePath = '${projectDir.path}/$fileName';

      await _downloadFile(client, foundIconUrl, filePath);
      localIconPath = filePath;
    }

    List<String> localScreenshotPaths = [];
    int sIndex = 1;
    for (final sUrl in foundScreenshotUrls.take(5)) {
      String ext = _getExtension(sUrl);
      final fileName = '${folderName}_image$sIndex$ext';
      final filePath = '${projectDir.path}/$fileName';

      await _downloadFile(client, sUrl, filePath);
      localScreenshotPaths.add(filePath);
      sIndex++;
    }

    // --- Generate Code Block with LOCAL paths ---
    newCodeBuffer.writeln('    ProjectModel(');
    newCodeBuffer.writeln('      name: "$name",');
    newCodeBuffer.writeln('      description: "$description",');

    if (appStoreUrl != null)
      newCodeBuffer.writeln('      appStoreUrl: "$appStoreUrl",');
    if (playStoreUrl != null)
      newCodeBuffer.writeln('      playStoreUrl: "$playStoreUrl",');

    if (localIconPath != null) {
      newCodeBuffer.writeln('      appIcon: "$localIconPath",');
    }

    if (localScreenshotPaths.isNotEmpty) {
      newCodeBuffer.writeln('      screenshots: [');
      for (final s in localScreenshotPaths) {
        newCodeBuffer.writeln('        "$s",');
      }
      newCodeBuffer.writeln('      ],');
    }

    if (technologies.isNotEmpty) {
      newCodeBuffer.writeln('      technologies: [$technologies],');
    } else {
      newCodeBuffer.writeln('      technologies: [],');
    }

    newCodeBuffer.writeln('    ),');
  }

  newCodeBuffer.writeln('  ];');
  client.close();

  print('\n--------------------------------------------------------------');
  print('DONE! Images downloaded to assets/projects/.');
  print('See below for the updated CODE block pointing to these local files.');
  print('--------------------------------------------------------------\n');
  print(newCodeBuffer.toString());
  print('\n--------------------------------------------------------------');
}

String _getExtension(String url) {
  // Simple heuristic
  if (url.contains('.png')) return '.png';
  if (url.contains('.jpg') || url.contains('.jpeg')) return '.jpg';
  if (url.contains('.webp')) return '.webp';
  return '.png'; // default
}

Future<void> _downloadFile(
  http.Client client,
  String url,
  String savePath,
) async {
  try {
    // Basic check if file exists (optional, maybe overwrite?) - Let's overwrite to ensure freshness.
    final response = await client.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final file = File(savePath);
      await file.writeAsBytes(response.bodyBytes);
      print('    Downloaded: $savePath');
    } else {
      print('    Failed download: $url (${response.statusCode})');
    }
  } catch (e) {
    print('    Error downloading $url: $e');
  }
}

String? _extractField(String block, String fieldName) {
  final regExp = RegExp('$fieldName:\\s*["\']([^"\']*)["\']');
  final match = regExp.firstMatch(block);
  return match?.group(1);
}

Future<Map<String, dynamic>> _scrapeStore(
  http.Client client,
  String url, {
  required bool isApple,
}) async {
  try {
    final response = await client.get(Uri.parse(url));
    if (response.statusCode != 200) return {};
    final html = response.body;

    if (isApple) {
      return _extractApple(html);
    } else {
      return _extractGoogle(html);
    }
  } catch (e) {
    print('    Error: $e');
    return {};
  }
}

Map<String, dynamic> _extractApple(String html) {
  String? icon;
  final List<String> screens = [];

  final iconMatch = RegExp(
    r'<meta property="og:image" content="([^"]+)"',
  ).firstMatch(html);
  if (iconMatch != null) icon = iconMatch.group(1);

  // Broad extraction for screenshots
  // Finding large image URLs in source srcset or typical Apple patterns
  // We clean the URL to remove parsing params like 300x650bb if simpler URL exists,
  // but often just using the regex logic for massive JPGs works.

  // Strategy: Find strings ending in .jpg or .png inside typical Apple containers or meta tags.
  // We'll stick to the "is1-ssl.mzstatic.com ... .jpg" logic.

  // Revised regex to find distinct large image URLs
  final imgRegExp = RegExp(
    r'https://is1-ssl\.mzstatic\.com/image/thumb/[^"]+\.jpg/[^"]+\.jpg',
  );
  final matches = imgRegExp.allMatches(html);

  for (final m in matches) {
    final u = m.group(0);
    if (u != null && !screens.contains(u)) {
      screens.add(u);
    }
  }

  return {'icon': icon, 'screenshots': screens};
}

Map<String, dynamic> _extractGoogle(String html) {
  String? icon;
  final List<String> screens = [];

  final iconMatch = RegExp(
    r'<meta property="og:image" content="([^"]+)"',
  ).firstMatch(html);
  if (iconMatch != null) icon = iconMatch.group(1);

  final imgRegExp = RegExp(
    r'(https://play-lh.googleusercontent.com/[a-zA-Z0-9_-]+)',
  );
  final matches = imgRegExp.allMatches(html);

  for (final m in matches) {
    final u = m.group(1);
    if (u != null && u != icon && u.length > 50 && !screens.contains(u)) {
      screens.add(u);
    }
  }

  return {'icon': icon, 'screenshots': screens};
}
