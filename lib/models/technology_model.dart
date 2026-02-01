import 'package:flutter/material.dart';

class TechnologyModel {
  final String name;
  final IconData? icon;
  final String? assetPath;
  final Color color;

  const TechnologyModel({
    required this.name,
    this.icon,
    this.assetPath,
    required this.color,
  });
}
