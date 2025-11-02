// TODO: Profile 기능에 대한 유스케이스를 정의하세요.
import 'package:dartz/dartz.dart';
import 'package:trip_mate/core/configs/usecases/usecase.dart';
import 'package:trip_mate/features/profile/domain/repositories/profile_repository.dart';
import 'package:trip_mate/service_locator.dart';

class LogoutProfileUseCase extends UseCase<Either, dynamic>{
  @override
  Future<Either> call({params}) async {
    return await sl<ProfileRepository>().logout();
  }
}
