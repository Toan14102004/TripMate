import '../../domain/entities/trip.dart';
import '../../domain/repositories/my_trip_repository.dart';
import '../sources/my_trip_api_service.dart';

class MyTripRepositoryImpl implements MyTripRepository {
  final MyTripApiService apiService;

  MyTripRepositoryImpl({required this.apiService});

  @override
  Future<List<Trip>> getMyTrips() async {
    final dtos = await apiService.fetchTrips();
    return dtos.map((dto) => dto.toEntity()).toList();
  }
}
