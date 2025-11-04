import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:trip_mate/commons/endpoint.dart';
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/core/api_client/api_client.dart';

import '../dtos/trip_dto.dart';

class MyTripApiService {
  Future<Either> fetchTrips({
    required String userId,
    String bookingStatus = 'pending',
    int page = 1,
    int limit = 4,
  }) async {
    final apiService = ApiService();
    return apiService.sendRequest(() async {
      final responseData = await apiService.get(
        AppEndPoints.kMyTripFilterPagination,
        queryParameters: {
          'userId': userId,
          'bookingStatus': bookingStatus,
          'page': page,
          'limit': limit,
        },
        skipAuth: false,
      );
      
      logDebug('MyTrip Response: $responseData');
      
      if (responseData is Map<String, dynamic>) {
        final statusCode = responseData['statusCode'] as int?;
        if (statusCode == 200 && responseData['data'] != null) {
          // Check if data contains bookings array
          final data = responseData['data'];
          List<dynamic> rawBookings = [];
          
          if (data is Map<String, dynamic>) {
            rawBookings = data['bookings'] as List<dynamic>? ?? [];
          } else if (data is List) {
            rawBookings = data;
          }
          
          logDebug('Found ${rawBookings.length} bookings');
          
          final trips = rawBookings
              .map((e) {
                try {
                  // If item has tour object, use it
                  final booking = e as Map<String, dynamic>;
                  final tourData = booking['tour'] ?? booking;
                  return TripDto.fromJson(tourData as Map<String, dynamic>);
                } catch (error) {
                  logDebug('Error parsing booking: $error');
                  return null;
                }
              })
              .where((trip) => trip != null)
              .cast<TripDto>()
              .toList();
          
          return Right(trips);
        } else {
          return Left(responseData['message'] ?? 'Lỗi khi lấy danh sách chuyến đi');
        }
      }
      
      return const Left('Lỗi định dạng dữ liệu từ máy chủ');
    });
  }

  // Mock API call - keep for fallback
  Future<Either> fetchTripsMock() async {
    await Future.delayed(const Duration(seconds: 1));
    final mockData = [
      {
        "id": "1",
        "title": "Jammu Kashmir",
        "location": "India",
        "duration": "2 days 3 nights full package",
        "rating": 4.8,
        "imageUrl":
            "https://images.unsplash.com/photo-1589308078059-be1415eab4c3?w=800",
      },
      {
        "id": "2",
        "title": "Rome, Italy",
        "location": "Italy",
        "duration": "2 days 3 nights full package",
        "rating": 4.7,
        "imageUrl":
            "https://images.unsplash.com/photo-1543340900-1bf3b4f9c5b9?w=800",
      },
      {
        "id": "3",
        "title": "Romantic Paris Getaway",
        "location": "France",
        "duration": "3 days 4 nights full package",
        "rating": 4.9,
        "imageUrl":
            "https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800",
      },
      {
        "id": "4",
        "title": "Discover Tokyo Culture",
        "location": "Japan",
        "duration": "4 days 3 nights",
        "rating": 4.8,
        "imageUrl":
            "https://images.unsplash.com/photo-1549692520-acc6669e2f0c?w=800",
      },
      {
        "id": "5",
        "title": "Relax in Beautiful Bali",
        "location": "Indonesia",
        "duration": "5 days 4 nights",
        "rating": 4.9,
        "imageUrl":
            "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800",
      },
      {
        "id": "6",
        "title": "Explore New York City",
        "location": "USA",
        "duration": "3 days 2 nights",
        "rating": 4.6,
        "imageUrl":
            "https://images.unsplash.com/photo-1549921296-3e3c0f1d5b35?w=800",
      },
      {
        "id": "7",
        "title": "Adventure in the Swiss Alps",
        "location": "Switzerland",
        "duration": "6 days 5 nights",
        "rating": 4.9,
        "imageUrl":
            "https://images.unsplash.com/photo-1504198453319-5ce911bafcde?w=800",
      },
      {
        "id": "8",
        "title": "Desert Safari Dubai",
        "location": "UAE",
        "duration": "2 days 1 night",
        "rating": 4.7,
        "imageUrl":
            "https://images.unsplash.com/photo-1504196606672-aef5c9cefc92?w=800",
      },
      {
        "id": "9",
        "title": "Visit the Great Wall of China",
        "location": "China",
        "duration": "3 days 2 nights",
        "rating": 4.8,
        "imageUrl":
            "https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=800",
      },
      {
        "id": "10",
        "title": "Santorini Sunset Experience",
        "location": "Greece",
        "duration": "3 days 2 nights",
        "rating": 4.9,
        "imageUrl":
            "https://images.unsplash.com/photo-1505731132164-cca3b4ae4010?w=800",
      },
    ];

    return Right(mockData.map((e) => TripDto.fromJson(e)).toList());
  }
}
