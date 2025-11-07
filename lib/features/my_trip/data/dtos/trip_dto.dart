import '../../domain/entities/trip.dart';

class TripDto {
  final String bookingId;
  final String id;
  final String title;
  final String location;
  final String imageUrl;
  final String duration;
  final double rating;

  TripDto({
    required this.bookingId,
    required this.id,
    required this.title,
    required this.location,
    required this.imageUrl,
    required this.duration,
    required this.rating,
  });

  factory TripDto.fromJson(Map<String, dynamic> json) {
    return TripDto(
      bookingId: json['bookingId']?.toString() ?? '',
      id: json['tour']['tourId']?.toString() ?? '',
      title: json['tour']['title']?.toString() ?? json['tour']['name']?.toString() ?? 'Unknown Trip',
      location: json['tour']['location']?.toString() ?? json['tour']['destination']?.toString() ?? 'Unknown Location',
      imageUrl: json['tour']['imageUrl']?.toString() ?? json['tour']['image']?.toString() ?? json['tour']['thumbnail']?.toString() ?? 'https://via.placeholder.com/800x500',
      duration: json['tour']['duration']?.toString() ?? json['tour']['subtitle']?.toString() ?? json['tour']['description']?.toString() ?? 'N/A',
      rating: (json['tour']['rating'] as num?)?.toDouble() ?? (json['tour']['starAvg'] as num?)?.toDouble() ?? (json['tour']['rate'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Trip toEntity() => Trip(
    bookingId: bookingId,
    id: id,
    title: title,
    location: location,
    imageUrl: imageUrl,
    duration: duration,
    rating: rating,
  );
}
