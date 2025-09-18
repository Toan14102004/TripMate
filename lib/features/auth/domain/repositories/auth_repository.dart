// TODO: Auth 기능에 대한 리포지토리 인터페이스를 정의하세요.
import 'package:dartz/dartz.dart';
import 'package:trip_mate/features/auth/data/dtos/signin_request.dart';
import 'package:trip_mate/features/auth/data/dtos/signup_request.dart';

abstract class AuthRepository {
  Future<Either> signInWithEmailAndPassword(SigninUserReq signInUserReq);
  Future<Either> signUpWithEmailAndPassword(CreateUserReq createUserReq);
  Future<Either> verifyToken(String token);
  Future<Either> resendToken();
}