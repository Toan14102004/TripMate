import 'package:dartz/dartz.dart';
import 'package:trip_mate/service_locator.dart';
import '../../domain/repositories/my_trip_repository.dart';
import '../sources/my_trip_api_service.dart';

class MyTripRepositoryImpl implements MyTripRepository {
  @override
  Future<Either> getMyTrips({
    required String userId,
    String bookingStatus = 'pending',
    int page = 1,
    int limit = 4,
  }) async {
    return await sl<MyTripApiService>().fetchTrips(
      userId: userId,
      bookingStatus: bookingStatus,
      page: page,
      limit: limit,
    );
  }
  
  @override
  Future<Either> deleteMyTrips() {
    // TODO: implement deleteMyTrips
    throw UnimplementedError();
  }
}
