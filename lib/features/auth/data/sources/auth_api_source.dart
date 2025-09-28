// TODO: Auth 기능의 API 소스를 구현하세요.
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/commons/storage_keys/auth.dart';
import 'package:trip_mate/core/ultils/generate_random_number.dart';
import 'package:trip_mate/features/auth/data/dtos/signin_request.dart';
import 'package:trip_mate/features/auth/data/dtos/signup_request.dart';

class AuthApiSource {
  Future<Either> signInWithEmailAndPassword(SigninUserReq signInUserReq) async {
    if(signInUserReq.email == 'test@example.com' && signInUserReq.password == 'password'){
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(AuthKeys.kEmail, signInUserReq.email);
      return const Right("Đăng nhập thành công!");
    }
    else{
      return const Left("Email hoặc mật khẩu không đúng");
    }
  }

  Future<Either> signUpWithEmailAndPassword(CreateUserReq createUserReq) async {
    final prefs = await SharedPreferences.getInstance();
    int verifyKey = generateRandomNumber(min: 1000, max: 9999);
    logDebug(createUserReq.fullName);
    prefs.setString(AuthKeys.kFullName, createUserReq.fullName);
    prefs.setString(AuthKeys.kDob, createUserReq.dob.toIso8601String());
    logDebug(verifyKey.toString());
    await prefs.setString(AuthKeys.kAuthVerifyKey, verifyKey.toString());
    return const Right("Đăng ký thành công!");
  }

  Future<Either> verifyToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    logDebug(prefs.getString(AuthKeys.kAuthVerifyKey) as Object);
    if(token == prefs.getString(AuthKeys.kAuthVerifyKey)){
      return const Right("Mã xác thực đã đúng");
    }
    return const Left("Mã xác thực bị sai");
  }

  Future<Either> resendToken() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      prefs.remove(AuthKeys.kAuthTokenKey);
      int verifyKey = generateRandomNumber(min: 1000, max: 9999);
      logDebug(verifyKey);
      prefs.setString(AuthKeys.kAuthVerifyKey, verifyKey.toString());
      return const Right("Thành công");
    }catch(e){
      return const Left("Thất bại");
    }
  }
}