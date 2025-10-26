// Get saved tours use case
import 'package:dartz/dartz.dart';
import 'package:trip_mate/features/saved/domain/repositories/saved_repository.dart';
import 'package:trip_mate/service_locator.dart';

class GetSavedToursUseCase {
  Future<Either> call({
    int page = 1,
    int limit = 4,
  }) async {
    return await sl<SavedRepository>().getSavedTours(
      page: page,
      limit: limit,
    );
  }
}