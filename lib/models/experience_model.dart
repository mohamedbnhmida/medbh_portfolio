class ExperienceModel {
  final String role;
  final String company;
  final String period;
  final String location;

  /// Company logo: asset path or image URL.
  final String? logo;

  const ExperienceModel({
    required this.role,
    required this.company,
    required this.period,
    required this.location,
    this.logo,
  });
}

class EducationModel {
  final String degree;
  final String institution;
  final String period;
  final String? logo;

  const EducationModel({
    required this.degree,
    required this.institution,
    required this.period,
    this.logo,
  });
}

class CertificationModel {
  final String name;
  final String date;
  final String? url;
  final String issuer;
  final String? logo;

  /// Certificate preview image (asset path or URL).
  final String? image;
  final String? credentialId;
  final List<String> skills;

  const CertificationModel({
    required this.name,
    required this.date,
    this.url,
    this.issuer = '',
    this.logo,
    this.image,
    this.credentialId,
    this.skills = const [],
  });
}
