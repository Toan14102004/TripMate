// TODO: Profile 기능에 대한 유스케이스를 정의하세요.
import 'package:dartz/dartz.dart';
import 'package:trip_mate/core/configs/usecases/usecase.dart';
import 'package:trip_mate/features/profile/domain/repositories/profile_repository.dart';
import 'package:trip_mate/features/profile/presentation/providers/profile_state.dart';
import 'package:trip_mate/service_locator.dart';

class UpdateProfileUseCase extends UseCase<Either, ProfileData>{
  @override
  Future<Either> call({ProfileData? params}) async {
    if(params == null){
      return const Left('Mising params');
    }
    return await sl<ProfileRepository>().updateProfile(params.convertToEntity());
  }
  
}
