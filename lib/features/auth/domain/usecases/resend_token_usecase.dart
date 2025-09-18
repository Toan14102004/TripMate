import 'package:dartz/dartz.dart';
import 'package:trip_mate/core/configs/usecases/usecase.dart';
import 'package:trip_mate/features/auth/domain/repositories/auth_repository.dart';
import 'package:trip_mate/service_locator.dart';

class ResendTokenUsecase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<AuthRepository>().resendToken();
  }
}