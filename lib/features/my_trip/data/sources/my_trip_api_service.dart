import 'dart:async';
import '../dtos/trip_dto.dart';

class MyTripApiService {
  // Mock API call
  Future<List<TripDto>> fetchTrips() async {
    await Future.delayed(const Duration(seconds: 1));
    final mockData = [
      {
        "id": "1",
        "title": "Jammu Kashmir",
        "location": "India",
        "imageUrl": "https://images.unsplash.com/photo-1600783245941-3f9e1ef5adf3",
        "duration": "2 days 3 nights",
        "rating": 4.8,
      },
      {
        "id": "2",
        "title": "Rome, Italy",
        "location": "Italy",
        "imageUrl": "https://images.unsplash.com/photo-1583853261119-73a55c2e96d0",
        "duration": "2 days 3 nights",
        "rating": 4.7,
      },
    ];

    return mockData.map((e) => TripDto.fromJson(e)).toList();
  }
}
