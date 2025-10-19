import 'package:trip_mate/commons/helpers/random_number.dart';

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

  factory TourModel.fromJson(Map<String, dynamic> json) {
    final rawTourId = json['tourId'];
    int? parsedTourId;
    if (rawTourId is int) {
      parsedTourId = rawTourId;
    } else if (rawTourId is String) {
      parsedTourId = int.tryParse(rawTourId);
    }

    final String? rawTitle = json['title'] as String?;
    if (rawTitle == null) {
      throw const FormatException('Title is required.');
    }

    final num? rawQuantity = json['quantity'] as num?;
    final num? rawPrice = json['price'] as num?;

    double? parseDouble(dynamic value) {
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    final double? parsedRating =
        parseDouble(json['starAvg']) ?? parseDouble(rawQuantity);
    final double safeRating =
        (parsedRating?.isFinite == true)
            ? parsedRating!
            : randomDoubleInRange(0, 10);

    final double? parsedPrice =
        parseDouble(json['price']) ?? parseDouble(rawPrice);
    final double safePrice =
        (parsedPrice?.isFinite == true)
            ? parsedPrice!
            : randomDoubleInRange(1000000, 10000000);

    final result = TourModel(
      tourId:
          parsedTourId ?? (throw const FormatException('Tour ID is required.')),
      title: rawTitle,

      image: (json['image'] as String?),

      destination: (json['destination'] as String?),
      description: (json['description'] as String?),
      reviewCount:
          (json['reviewCount'] as int?) ?? randomIntInRange(10, 1000),

      rating: safeRating,
      price: safePrice,

      subtitle: (json['subtitle'] as String?),
      isBookmarked: (json['isBookmarked'] as bool?),
    );
    return result;
  }
}
