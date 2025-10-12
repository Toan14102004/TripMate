class TourModel {
  final int tourId;
  final String title;
  final String? description;
  final String? image;
  final String? destination;
  final double? rating;
  final int? reviewCount;
  final double? price;
  final String? subtitle;
  final bool? isBookmarked;

  TourModel({
    required this.tourId,
    required this.title,
    this.description,
    this.image,
    this.destination,
    this.rating,
    this.reviewCount,
    this.price,
    this.subtitle,
    this.isBookmarked,
  });
}