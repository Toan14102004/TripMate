// TODO: Security 기능에 대한 리포지토리 인터페이스를 정의하세요.
import 'package:dartz/dartz.dart';
import 'package:trip_mate/features/security/data/dtos/new_pass_request.dart';

abstract class SecurityRepository {
  Future<Either> resetPassword(String email);
  Future<Either> newPassword(NewPasswordRequest req);
}