// TODO: Auth 기능에 대한 유스케이스를 정의하세요.
import 'package:dartz/dartz.dart';
import 'package:trip_mate/core/configs/usecases/usecase.dart';
import 'package:trip_mate/features/auth/data/dtos/signup_request.dart';
import 'package:trip_mate/features/auth/domain/repositories/auth_repository.dart';
import 'package:trip_mate/service_locator.dart';

class SignUpUseCase implements UseCase<Either, CreateUserReq> {
  @override
  Future<Either> call({CreateUserReq? params}) async {
    // handle null if needed
    if (params == null) {
      return const Left("Missing params");
    }
    return await sl<AuthRepository>().signUpWithEmailAndPassword(params);
  }
}
