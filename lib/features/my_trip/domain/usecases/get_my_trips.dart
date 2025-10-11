import '../entities/trip.dart';
import '../repositories/my_trip_repository.dart';

class GetMyTrips {
  final MyTripRepository repository;

  GetMyTrips(this.repository);

  Future<List<Trip>> call() async {
    return await repository.getMyTrips();
  }
}
