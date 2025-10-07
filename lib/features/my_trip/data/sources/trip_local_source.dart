import '../dtos/trip_dto.dart';

/// Local cache mock (optionally use hive/shared_preferences)
class TripLocalSource {
  final List<TripDto> _cache = [];

  Future<void> cacheTrips(List<TripDto> dtos) async {
    _cache.clear();
    _cache.addAll(dtos);
  }

  Future<List<TripDto>> getCachedTrips() async {
    return _cache;
  }
}
