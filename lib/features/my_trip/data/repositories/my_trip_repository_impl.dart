import 'package:dartz/dartz.dart';
import 'package:trip_mate/service_locator.dart';
import '../../domain/repositories/my_trip_repository.dart';
import '../sources/my_trip_api_service.dart';

class MyTripRepositoryImpl implements MyTripRepository {
  @override
  Future<Either> getMyTrips() async {
    return await sl<MyTripApiService>().fetchTrips();
  }
  
  @override
  Future<Either> deleteMyTrips() {
    // TODO: implement deleteMyTrips
    throw UnimplementedError();
  }
}
