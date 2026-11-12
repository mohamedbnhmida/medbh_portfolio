enum ProjectType { mobile, webDesktop }

class ProjectModel {
  final String name;
  final String description;
  final String? appIcon;
  final String? playStoreUrl;
  final String? appStoreUrl;
  final String? webUrl;
  final String? apkUrl; // direct APK download (sideload)
  final String? apkQrCode; // asset: QR code pointing to [apkUrl]
  final String? githubUrl;
  final List<String> technologies;
  final List<String>? screenshots;
  final ProjectType projectType;
  final List<String> highlights;

  const ProjectModel({
    required this.name,
    required this.description,
    this.appIcon,
    this.playStoreUrl,
    this.appStoreUrl,
    this.webUrl,
    this.apkUrl,
    this.apkQrCode,
    this.githubUrl,
    required this.technologies,
    this.screenshots,
    this.projectType = ProjectType.mobile,
    this.highlights = const [],
  });
}
