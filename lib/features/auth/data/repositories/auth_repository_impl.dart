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
  Future<Either> verifyPassToken(String token, String email, String newPass) async {
    return await sl<AuthApiSource>().verifyPassToken(token, email, newPass);
  }

  @override
  Future<Either> verifyEmailToken(String token, String email) async {
    return await sl<AuthApiSource>().verifyEmailToken(token, email);
  }
  
  @override
  Future<Either> resendToken(String email) async {
    return await sl<AuthApiSource>().resendToken(email);
  }
}