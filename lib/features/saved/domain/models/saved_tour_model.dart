class SavedTourModel {
  final int tourId;
  final String title;
  final String subtitle;
  final String image;
  final double rating;
  final bool isBookmarked;

  SavedTourModel({
    required this.tourId,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.rating,
    this.isBookmarked = true,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'tourId': tourId,
      'title': title,
      'subtitle': subtitle,
      'image': image,
      'rating': rating,
      'isBookmarked': isBookmarked,
    };
  }

  // Create from JSON
  factory SavedTourModel.fromJson(Map<String, dynamic> json) {
    return SavedTourModel(
      tourId: json['tourId'] as int,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      image: json['image'] as String,
      rating: (json['rating'] as num).toDouble(),
      isBookmarked: json['isBookmarked'] == true, // Safe null handling
    );
  }

  // Copy with method for updating properties
  SavedTourModel copyWith({
    int? tourId,
    String? title,
    String? subtitle,
    String? image,
    double? rating,
    bool? isBookmarked,
  }) {
    return SavedTourModel(
      tourId: tourId ?? this.tourId,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}
