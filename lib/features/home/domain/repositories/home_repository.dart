// TODO: Home 기능에 대한 리포지토리 인터페이스를 정의하세요.
import 'package:trip_mate/features/home/domain/models/tour_detail_model.dart';

abstract class HomeRepository {
  Future<TourDetailModel> getTourDetail(int tourId);
}
