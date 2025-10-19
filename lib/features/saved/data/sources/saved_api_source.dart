// Saved API source for calling backend
import 'package:dartz/dartz.dart';
import 'package:trip_mate/commons/endpoint.dart';
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/core/api_client/api_client.dart';
import 'package:trip_mate/features/saved/data/dtos/saved_response.dart';
import 'package:trip_mate/features/saved/domain/models/saved_tour_model.dart';
import 'package:trip_mate/features/saved/presentation/providers/saved_state.dart';

class SavedApiSource {
  final List<SavedTourModel> savedTours = [
  SavedTourModel(
    tourId: 1,
    title: 'Jammu Kashmir',
    subtitle: '2 days 3 night full package',
    image: 'assets/images/laguna.png', // Using available image as placeholder
    rating: 4.8,
    isBookmarked: true,
  ),
  SavedTourModel(
    tourId: 2,
    title: 'Rome, Italy',
    subtitle: '2 days 3 night full package',
    image: 'assets/images/luxury_hotel.png', // Using available image as placeholder
    rating: 4.7,
    isBookmarked: true,
  ),
  SavedTourModel(
    tourId: 3,
    title: 'Blue House Resort',
    subtitle: '3 days 2 night full package',
    image: 'assets/images/blue_house.png',
    rating: 4.9,
    isBookmarked: true,
  ),
  SavedTourModel(
    tourId: 4,
    title: 'Apanemo Resort',
    subtitle: '2 days 3 night full package',
    image: 'assets/images/apanemo.png',
    rating: 4.8,
    isBookmarked: true,
  ),
  SavedTourModel(
    tourId: 5,
    title: 'Hilton Resort',
    subtitle: '4 days 3 night full package',
    image: 'assets/images/hilton.png',
    rating: 4.6,
    isBookmarked: true,
  ),
];

  Future<Either> getSavedTours() async {
    final apiService = ApiService();
    return apiService.sendRequest(() async {
      final responseData = await apiService.get(
        AppEndPoints.kSavedTours,
        skipAuth: false,
      );
      logDebug(responseData);
      
      if (responseData is Map<String, dynamic>) {
        final savedListResponse = SavedListResponse.fromJson(responseData);
        final entities = savedListResponse.convertToEntities();
        
        // Convert entities to models for state
        final models = entities.map((e) => e.toModel()).toList();
        return Right(SavedToursData(tours: models));
      } else if (responseData is List) {
        // Handle case where API returns array directly
        final tours = responseData.map((item) => 
          SavedResponse.fromJson(item as Map<String, dynamic>).convertToEntity()
        ).toList();
        
        // Convert entities to models for state
        final models = tours.map((e) => e.toModel()).toList();
        return Right(SavedToursData(tours: savedTours));
      }
      
      return const Left("Lỗi định dạng dữ liệu saved tours từ máy chủ.");
    });
    // return Right(SavedToursData(tours: savedTours));
  }
}