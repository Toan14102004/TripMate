// TODO: Security 기능의 리포지토리를 구현하세요.
import 'package:dartz/dartz.dart';
import 'package:trip_mate/features/security/data/dtos/new_pass_request.dart';
import 'package:trip_mate/features/security/data/sources/security_api_source.dart';
import 'package:trip_mate/features/security/domain/repositories/security_repository.dart';
import 'package:trip_mate/service_locator.dart';

class SecurityRepositoryImpl implements SecurityRepository {
  @override
  Future<Either> resetPassword(String email) {
    return sl<SecurityApiSource>().resetPassword(email);
  }

  @override
  Future<Either> newPassword(NewPasswordRequest req) {
    return sl<SecurityApiSource>().newPassword(req);
  }
}