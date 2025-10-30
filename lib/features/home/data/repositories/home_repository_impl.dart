import 'package:trip_mate/features/home/data/sources/home_api_source.dart';
import 'package:trip_mate/features/home/domain/models/tour_detail_model.dart';
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
}
