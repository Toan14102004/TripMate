// TODO: MyTrip 기능에 대한 유스케이스를 정의하세요.
import 'package:dartz/dartz.dart';
import 'package:trip_mate/features/my_trip/domain/repositories/my_trip_repository.dart';
import 'package:trip_mate/service_locator.dart';

class GetMyTripToursUseCase {
  Future<Either> call({
    required String userId,
    String bookingStatus = 'pending',
    int page = 1,
    int limit = 4,
  }) async {
    return await sl<MyTripRepository>().getMyTrips(
      userId: userId,
      bookingStatus: bookingStatus,
      page: page,
      limit: limit,
    );
  }
}
