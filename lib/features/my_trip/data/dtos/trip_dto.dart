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
      id: json['id']?.toString() ?? json['tourId']?.toString() ?? json['bookingId']?.toString() ?? '',
      title: json['title']?.toString() ?? json['name']?.toString() ?? 'Unknown Trip',
      location: json['location']?.toString() ?? json['destination']?.toString() ?? 'Unknown Location',
      imageUrl: json['imageUrl']?.toString() ?? json['image']?.toString() ?? json['thumbnail']?.toString() ?? 'https://via.placeholder.com/800x500',
      duration: json['duration']?.toString() ?? json['subtitle']?.toString() ?? json['description']?.toString() ?? 'N/A',
      rating: (json['rating'] as num?)?.toDouble() ?? (json['starAvg'] as num?)?.toDouble() ?? (json['rate'] as num?)?.toDouble() ?? 0.0,
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
