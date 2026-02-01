class ProjectModel {
  final String name;
  final String description;
  final String? appIcon;
  final String? playStoreUrl;
  final String? appStoreUrl;
  final List<String> technologies;
  final List<String>? screenshots;

  const ProjectModel({
    required this.name,
    required this.description,
    this.appIcon,
    this.playStoreUrl,
    this.appStoreUrl,
    required this.technologies,
    this.screenshots,
  });
}
