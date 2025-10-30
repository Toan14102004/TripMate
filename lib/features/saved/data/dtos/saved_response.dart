// Saved tours response from API
import 'package:trip_mate/features/saved/domain/entities/saved_entity.dart';

class SavedResponse {
  final int tourId;
  final String? title;
  final String? subtitle;
  final String? image;
  final double? rating;
  final bool? isBookmarked;

  SavedResponse({
    required this.tourId,
    this.title,
    this.subtitle,
    this.image,
    this.rating,
    this.isBookmarked,
  });

  factory SavedResponse.fromJson(Map<String, dynamic> json) {
    return SavedResponse(
      tourId: json['tourId'] as int? ?? json['id'] as int? ?? 0,
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String? ?? json['description'] as String?,
      image: json['image'] as String? ?? json['imageUrl'] as String?,
      rating: (json['starAvg'] as num?)?.toDouble(),
      isBookmarked: json['isBookmarked'] as bool? ?? true,
    );
  }

  SavedEntity convertToEntity() {
    return SavedEntity(
      tourId: tourId,
      title: title ?? 'Unknown',
      subtitle: subtitle ?? 'No description',
      image: image ?? 'assets/images/travel_bg.jpg',
      rating: rating ?? 0.0,
      isBookmarked: isBookmarked ?? true,
    );
  }
}

class SavedListResponse {
  final List<SavedResponse> tours;

  SavedListResponse({required this.tours});

  factory SavedListResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> favouritesJson = json['data']['favourites'] as List<dynamic>? ?? [];
    
    return SavedListResponse(
      tours: favouritesJson
          .map((favouriteJson) {
            final Map<String, dynamic> tourData = favouriteJson['tour'] as Map<String, dynamic>? ?? {};
            return SavedResponse.fromJson(tourData);
          })
          .toList(),
    );
  }

  List<SavedEntity> convertToEntities() {
    return tours.map((tour) => tour.convertToEntity()).toList();
  }
}
