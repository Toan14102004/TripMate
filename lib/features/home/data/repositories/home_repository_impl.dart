import 'package:trip_mate/features/home/data/sources/home_api_source.dart';
import 'package:trip_mate/features/home/domain/models/tour_detail_model.dart';
import 'package:trip_mate/features/home/domain/models/hashtag_model.dart';
import 'package:trip_mate/features/home/domain/models/review_model.dart';
import 'package:trip_mate/features/home/domain/repositories/home_repository.dart';
import 'package:trip_mate/service_locator.dart';

class HomeRepositoryImpl implements HomeRepository {
  @override
  Future<TourDetailModel> getTourDetail(int tourId) async {
    try {
      return await sl<HomeApiSource>().getTourDetail(tourId);
    } catch (e) {
      throw Exception('Failed to fetch tour detail: $e');
    }
  }

  @override
  Future<List<HashtagModel>> getTourHashtags(int tourId) async {
    try {
      return await sl<HomeApiSource>().fetchTourHashtags(tourId);
    } catch (e) {
      throw Exception('Failed to fetch hashtags: $e');
    }
  }

  @override
  Future<List<ReviewModel>> getTourReviews(int tourId, {int page = 1, int limit = 5}) async {
    try {
      return await sl<HomeApiSource>().fetchTourReviews(tourId, page: page, limit: limit);
    } catch (e) {
      throw Exception('Failed to fetch reviews: $e');
    }
  }

  @override
  Future<ReviewModel> submitReview({
    required int tourId,
    required int userId,
    required int rating,
    required String comment,
  }) async {
    try {
      return await sl<HomeApiSource>().submitReview(
        tourId: tourId,
        userId: userId,
        rating: rating,
        comment: comment,
      );
    } catch (e) {
      throw Exception('Failed to submit review: $e');
    }
  }
}
