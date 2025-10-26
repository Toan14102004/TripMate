// Saved API source for calling backend
import 'package:dartz/dartz.dart';
import 'package:trip_mate/commons/endpoint.dart';
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/core/api_client/api_client.dart';
import 'package:trip_mate/features/saved/data/dtos/saved_response.dart';
import 'package:trip_mate/features/saved/domain/models/saved_tour_model.dart';
import 'package:trip_mate/features/saved/presentation/providers/saved_state.dart';

class SavedApiSource {


  Future<Either> getSavedTours({
    int page = 1,
    int limit = 4,
  }) async {
    final apiService = ApiService();
    return apiService.sendRequest(() async {
      final responseData = await apiService.get(
        '${AppEndPoints.kSavedTours}?page=$page&limit=$limit',
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
        return Right(SavedToursData(tours: models));
      }
      
      return const Left("Lỗi định dạng dữ liệu saved tours từ máy chủ.");
    });
    // return Right(SavedToursData(tours: savedTours));
  }
}