class DesignerPortfolio {
  final String title;
  final String description;
  final String year;
  final List<PortfolioMedia> media;

  DesignerPortfolio({
    required this.title,
    required this.description,
    required this.year,
    required this.media,
  });

  factory DesignerPortfolio.fromJson(Map<String, dynamic> json) {
    return DesignerPortfolio(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      year: json['year'] ?? '',
      media: (json['portfolio_media'] as List? ?? [])
          .map((e) => PortfolioMedia.fromJson(e))
          .toList(),
    );
  }
}
class PortfolioMedia {
  final String mediaType;
  final String fileUrl;

  PortfolioMedia({
    required this.mediaType,
    required this.fileUrl,
  });

  factory PortfolioMedia.fromJson(Map<String, dynamic> json) {
    return PortfolioMedia(
      mediaType: json['media_type'] ?? '',
      fileUrl: json['file_url'] ?? '',
    );
  }
}
