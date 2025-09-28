// TODO: Profile 기능에 대한 리포지토리 인터페이스를 정의하세요.
import 'package:dartz/dartz.dart';
import 'package:trip_mate/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either> getProfile();
  Future<Either> updateProfile(ProfileEntity entity);
  Future<Either> logout();
}