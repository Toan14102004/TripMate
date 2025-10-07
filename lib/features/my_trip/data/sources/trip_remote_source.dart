import 'dart:async';
import '../dtos/trip_dto.dart';

/// Fake remote source - replace with real HTTP client later
class TripRemoteSource {
  Future<List<TripDto>> fetchTrips() async {
    await Future.delayed(const Duration(milliseconds: 600)); // simulate network
    final data = [
      {
        'id': 't1',
        'title': 'Jammu Kashmir',
        'location': 'Jammu Kashmir',
        'subtitle': '2 days 3 night full package',
        'imageUrl': 'https://picsum.photos/800/500?image=1050',
        'rating': 4.8,
        'days': 5,
        'description': 'Kashmir was a region formerly administered by India...',
        'pricePerNight': 171.25,
      },
      {
        'id': 't2',
        'title': 'Rome, Italy',
        'location': 'Rome, Italy',
        'subtitle': '2 days 3 night full package',
        'imageUrl': 'https://picsum.photos/800/500?image=1025',
        'rating': 4.7,
        'days': 3,
        'description': 'Rome is the capital city of Italy, rich with history and art.',
        'pricePerNight': 199.95,
      },
    ];
    return data.map((e) => TripDto.fromJson(e)).toList();
  }
}
