import '../../domain/entities/trip.dart';

class TripDto {
  final String id;
  final String title;
  final String location;
  final String imageUrl;
  final String duration;
  final double rating;

  TripDto({
    required this.id,
    required this.title,
    required this.location,
    required this.imageUrl,
    required this.duration,
    required this.rating,
  });

  factory TripDto.fromJson(Map<String, dynamic> json) {
    return TripDto(
      id: json['id'],
      title: json['title'],
      location: json['location'],
      imageUrl: json['imageUrl'],
      duration: json['duration'],
      rating: (json['rating'] as num).toDouble(),
    );
  }

  Trip toEntity() => Trip(
    id: id,
    title: title,
    location: location,
    imageUrl: imageUrl,
    duration: duration,
    rating: rating,
  );
}
