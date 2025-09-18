// TODO: Auth 기능의 리포지토리를 구현하세요.

import 'package:dartz/dartz.dart';
import 'package:trip_mate/features/auth/data/dtos/signin_request.dart';
import 'package:trip_mate/features/auth/data/dtos/signup_request.dart';
import 'package:trip_mate/features/auth/data/sources/auth_api_source.dart';
import 'package:trip_mate/features/auth/domain/repositories/auth_repository.dart';
import 'package:trip_mate/service_locator.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either> signInWithEmailAndPassword(SigninUserReq signInUserReq) async {
    return await sl<AuthApiSource>().signInWithEmailAndPassword(signInUserReq);
  }

  @override
  Future<Either> signUpWithEmailAndPassword(CreateUserReq createUserReq) async {
    return await sl<AuthApiSource>().signUpWithEmailAndPassword(createUserReq);
  }
  
  @override
  Future<Either> verifyToken(String token) async {
    return await sl<AuthApiSource>().verifyToken(token);
  }
  
  @override
  Future<Either> resendToken() async {
    return await sl<AuthApiSource>().resendToken();
  }
}