// Saved repository implementation
import 'package:dartz/dartz.dart';
import 'package:trip_mate/features/saved/data/sources/saved_api_source.dart';
import 'package:trip_mate/features/saved/domain/repositories/saved_repository.dart';
import 'package:trip_mate/service_locator.dart';

class SavedRepositoryImpl implements SavedRepository {
  @override
  Future<Either> getSavedTours() async {
    return await sl<SavedApiSource>().getSavedTours();
  }
}
