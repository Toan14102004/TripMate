import 'package:trip_mate/features/home/domain/models/tour_detail_model.dart';
import 'package:trip_mate/features/home/domain/models/hashtag_model.dart';
import 'package:trip_mate/features/home/domain/models/review_model.dart';

abstract class HomeRepository {
  Future<TourDetailModel> getTourDetail(int tourId);
  Future<List<HashtagModel>> getTourHashtags(int tourId);
  Future<List<ReviewModel>> getTourReviews(int tourId, {int page = 1, int limit = 5});
  Future<ReviewModel> submitReview({
    required int tourId,
    required int userId,
    required int rating,
    required String comment,
  });
}
