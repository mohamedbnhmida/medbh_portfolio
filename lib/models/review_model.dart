class ReviewModel {
  final String name;
  final String role;
  final String company;
  final String text;
  final String initials;
  final String source;
  final String sourceUrl;

  /// 1-5 stars; 0 = not rated (hidden).
  final int rating;

  const ReviewModel({
    required this.name,
    required this.role,
    required this.company,
    required this.text,
    required this.initials,
    required this.source,
    required this.sourceUrl,
    this.rating = 0,
  });
}
