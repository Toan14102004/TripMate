
import 'package:trip_mate/features/my_trip/data/repositories/trip_repository.dart';

import '../entities/trip.dart';


class GetMyTrips {
  final TripRepository repository;
  GetMyTrips(this.repository);

  Future<List<Trip>> call() async {
    return await repository.getTrips();
  }
}
