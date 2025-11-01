class ReviewModel {
  final int reviewId;
  final int tourId;
  final int userId;
  final int rating;
  final String comment;
  final String userName;
  final String userAvatar;
  final DateTime createDate;

  ReviewModel({
    required this.reviewId,
    required this.tourId,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.userName,
    required this.userAvatar,
    required this.createDate,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      reviewId: json['reviewId'] as int? ?? 0,
      tourId: json['tourId'] as int? ?? 0,
      userId: json['userId'] as int? ?? 0,
      rating: json['rating'] as int? ?? 0,
      comment: json['comment'] as String? ?? '',
      userName: json['userName'] as String? ?? 'Anonymous',
      userAvatar: json['userAvatar'] as String? ?? '',
      createDate: DateTime.tryParse(json['createDate'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
