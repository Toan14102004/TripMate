// Saved entity representing a saved tour
import 'package:trip_mate/features/saved/domain/models/saved_tour_model.dart';

class SavedEntity {
  final int tourId;
  final String title;
  final String subtitle;
  final String image;
  final double rating;
  final bool isBookmarked;

  SavedEntity({
    required this.tourId,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.rating,
    this.isBookmarked = true,
  });

  // Convert to SavedTourModel for presentation layer
  SavedTourModel toModel() {
    return SavedTourModel(
      tourId: tourId,
      title: title,
      subtitle: subtitle,
      image: image,
      rating: rating,
      isBookmarked: isBookmarked,
    );
  }
}
