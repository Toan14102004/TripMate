import 'package:dartz/dartz.dart';
import 'package:trip_mate/core/configs/usecases/usecase.dart';
import 'package:trip_mate/features/security/data/dtos/new_pass_request.dart';
import 'package:trip_mate/features/security/domain/repositories/security_repository.dart';
import 'package:trip_mate/service_locator.dart';

class NewPassUseCase implements UseCase<Either, NewPasswordRequest> {
  @override
  Future<Either> call({NewPasswordRequest? params}) async {
    // handle null if needed
    if (params == null) {
      return const Left("Missing params");
    }
    return await sl<SecurityRepository>().newPassword(params);
  }
}
