import '../../domain/entities/trip.dart';

class TripDto {
  final String id;
  final String title;
  final String location;
  final String subtitle;
  final String imageUrl;
  final double rating;
  final int days;
  final String description;
  final double pricePerNight;

  TripDto({
    required this.id,
    required this.title,
    required this.location,
    required this.subtitle,
    required this.imageUrl,
    required this.rating,
    required this.days,
    required this.description,
    required this.pricePerNight,
  });

  factory TripDto.fromJson(Map<String, dynamic> json) => TripDto(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    location: json['location'] ?? '',
    subtitle: json['subtitle'] ?? '',
    imageUrl: json['imageUrl'] ?? '',
    rating: (json['rating'] ?? 0).toDouble(),
    days: (json['days'] ?? 0),
    description: json['description'] ?? '',
    pricePerNight: (json['pricePerNight'] ?? 0).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'location': location,
    'subtitle': subtitle,
    'imageUrl': imageUrl,
    'rating': rating,
    'days': days,
    'description': description,
    'pricePerNight': pricePerNight,
  };

  Trip toEntity() {
    return Trip(
      id: id,
      title: title,
      location: location,
      subtitle: subtitle,
      imageUrl: imageUrl,
      rating: rating,
      days: days,
      description: description,
      pricePerNight: pricePerNight,
    );
  }
}
