import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TechnologyModel {
  final String name;
  final FaIconData? icon;
  final String? assetPath;

  /// From Firestore: an asset path, an image URL, or an SVG URL (e.g. cdn.simpleicons.org/swift).
  final String? iconUrl;
  final Color color;

  const TechnologyModel({
    required this.name,
    this.icon,
    this.assetPath,
    this.iconUrl,
    required this.color,
  });
}
