enum ProjectType { mobile, webDesktop }

class ProjectModel {
  final String name;
  final String description;
  final String? appIcon;
  final String? playStoreUrl;
  final String? appStoreUrl;
  final String? webUrl;
  final List<String> technologies;
  final List<String>? screenshots;
  final ProjectType projectType;

  const ProjectModel({
    required this.name,
    required this.description,
    this.appIcon,
    this.playStoreUrl,
    this.appStoreUrl,
    this.webUrl,
    required this.technologies,
    this.screenshots,
    this.projectType = ProjectType.mobile,
  });
}
