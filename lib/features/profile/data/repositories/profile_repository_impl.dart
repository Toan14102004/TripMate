// TODO: Profile 기능의 리포지토리를 구현하세요.
import 'package:dartz/dartz.dart';
import 'package:trip_mate/features/profile/data/sources/profile_api_source.dart';
import 'package:trip_mate/features/profile/domain/entities/profile_entity.dart';
import 'package:trip_mate/features/profile/domain/repositories/profile_repository.dart';
import 'package:trip_mate/service_locator.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  @override
  Future<Either> getProfile() async {
    return await sl<ProfileApiSource>().getProfile();
  }

  @override
  Future<Either> updateProfile(ProfileEntity entity) async {
    return await sl<ProfileApiSource>().updateProfile(entity.convertToRequest());
  }
  
  @override
  Future<Either> logout() async {
    return await sl<ProfileApiSource>().logout();
  }
}