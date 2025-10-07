import 'package:trip_mate/features/my_trip/domain/entities/trip.dart';

//import 'package:trip_mate/features/my_trip/data/entities/trip.dart';

abstract class TripRepository {
  Future<List<Trip>> getTrips();
  Future<Trip?> getTripById(String id);
}
