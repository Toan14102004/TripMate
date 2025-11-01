import 'package:trip_mate/features/home/domain/models/image_model.dart';
import 'package:trip_mate/features/home/domain/models/time_line_item.dart';
import 'package:trip_mate/features/home/domain/models/user_model.dart';
import 'package:trip_mate/features/home/domain/models/hashtag_model.dart';
import 'package:trip_mate/features/home/domain/models/review_model.dart';

class TourDetailModel {
  final int tourId;
  final String title;
  final String slug;
  final String description;
  final String image;
  final String destination;
  final String itinerary;
  final String time;
  final String reviews;
  final String domain;
  final int quantity;
  final int countComplete;
  final String address;
  final String status;
  final DateTime createDate;
  final DateTime updateDate;
  final UserModel user;
  final List<TimelineItem> timelines;
  final List<ImageModel> images;
  final List<HashtagModel> hashtags;
  final List<ReviewModel> reviewList;

  TourDetailModel({
    required this.tourId,
    required this.title,
    required this.slug,
    required this.description,
    required this.image,
    required this.destination,
    required this.itinerary,
    required this.time,
    required this.reviews,
    required this.domain,
    required this.quantity,
    required this.countComplete,
    required this.address,
    required this.status,
    required this.createDate,
    required this.updateDate,
    required this.user,
    required this.timelines,
    required this.images,
    this.hashtags = const [],
    this.reviewList = const [],
  });

  factory TourDetailModel.fromTourJson(Map<String, dynamic> json) {
    String _safeString(dynamic value) {
      if (value is String) return value;
      return '';
    }

    return TourDetailModel(
      tourId: json['tourId'] as int? ?? 0,
      title: _safeString(json['title']),
      slug: _safeString(json['slug']),
      description: _safeString(json['description']),
      image: _safeString(json['image']),
      destination: _safeString(json['destination']),
      itinerary: _safeString(json['itinerary']),
      time: _safeString(json['time']),
      reviews: _safeString(json['reviews']),
      domain: _safeString(json['domain']),
      quantity: json['quantity'] as int? ?? 0,
      countComplete: json['countComplete'] as int? ?? 0,
      address: _safeString(json['address']),
      status: _safeString(json['status']),
      createDate: DateTime.tryParse(json['createDate'] as String? ?? '') ?? DateTime.now(),
      updateDate: DateTime.tryParse(json['updateDate'] as String? ?? '') ?? DateTime.now(),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
      timelines: [],
      images: [],
      hashtags: [],
      reviewList: [],
    );
  }

  TourDetailModel copyWith({
    List<TimelineItem>? timelines,
    List<ImageModel>? images,
    List<HashtagModel>? hashtags,
    List<ReviewModel>? reviewList,
  }) {
    return TourDetailModel(
      tourId: tourId,
      title: title,
      slug: slug,
      description: description,
      image: image,
      destination: destination,
      itinerary: itinerary,
      time: time,
      reviews: reviews,
      quantity: quantity,
      domain: domain,
      countComplete: countComplete,
      address: address,
      status: status,
      createDate: createDate,
      updateDate: updateDate,
      user: user,
      timelines: timelines ?? this.timelines,
      images: images ?? this.images,
      hashtags: hashtags ?? this.hashtags,
      reviewList: reviewList ?? this.reviewList,
    );
  }
}
