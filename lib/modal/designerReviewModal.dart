class DesignerReview {
  final String name;
  final String date;
  final String image;
  final String review;
  final String comment;

  DesignerReview({
    required this.name,
    required this.date,
    required this.image,
    this.review= "",
    required this.comment,
  });
}