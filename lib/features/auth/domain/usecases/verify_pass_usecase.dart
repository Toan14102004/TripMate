import 'package:dartz/dartz.dart';
import 'package:trip_mate/core/configs/usecases/usecase.dart';
import 'package:trip_mate/features/auth/domain/repositories/auth_repository.dart';
import 'package:trip_mate/service_locator.dart';

class VerifyPassUseCase implements UseCase<Either, Map<String, String>> {
  @override
  Future<Either> call({Map<String, String>? params}) async {
    // handle null if needed
    if (params == null) {
      return const Left("Missing params");
    }
    return await sl<AuthRepository>().verifyPassToken(params['token']!, params['email']!, params['newPass']!);
  }
}