// Saved repository interface
import 'package:dartz/dartz.dart';

abstract class SavedRepository {
  Future<Either> getSavedTours({
    int page = 1,
    int limit = 4,
  });
}