class ReviewModel {
  final int reviewId;
  final int tourId; // Now extracted from the nested 'tour' object
  final int userId;
  final int rating;
  final String comment;
  final String userName;
  final String? userAvatar; // Can be null in your data

  // Added Tour Title for better context in the model
  final String tourTitle; 
  final DateTime createDate;

  ReviewModel({
    required this.reviewId,
    required this.tourId,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.userName,
    required this.tourTitle,
    this.userAvatar,
    required this.createDate,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    // Use safe access to nested maps
    final tour = json['tour'] as Map<String, dynamic>?;
    final user = json['user'] as Map<String, dynamic>?;

    return ReviewModel(
      // Review-level fields (Direct access)
      reviewId: json['reviewId'] as int? ?? 0,
      rating: json['rating'] as int? ?? 0,
      comment: json['comment'] as String? ?? '',
      createDate: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),

      // Nested 'tour' fields (using the 'tour' key from your latest data)
      tourId: tour?['tourId'] as int? ?? 0,
      tourTitle: tour?['title'] as String? ?? 'Unknown Tour',

      // Nested 'user' fields
      userId: user?['userId'] as int? ?? 0,
      userName: user?['fullName'] as String? ?? user?['userName'] as String? ?? 'Anonymous',
      userAvatar: user?['avatar'] as String?, // Keep it nullable
    );
  }
}