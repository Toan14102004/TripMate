// TODO: Auth 기능의 API 소스를 구현하세요.
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/commons/storage_keys/auth.dart';
import 'package:trip_mate/features/auth/data/dtos/signin_request.dart';
import 'package:trip_mate/features/auth/data/dtos/signup_request.dart';

class AuthApiSource {
  Future<Either> signInWithEmailAndPassword(SigninUserReq signInUserReq) async {
    if(signInUserReq.email == 'test@example.com' && signInUserReq.password == 'password'){
      return const Right("Đăng nhập thành công!");
    }
    else{
      return const Left("Email hoặc mật khẩu không đúng");
    }
  }

  int _generateRandomNumber() {
    final random = Random();
    int min = 1000;
    int max = 9999;
    return min + random.nextInt(max - min + 1);
  }

  Future<Either> signUpWithEmailAndPassword(CreateUserReq createUserReq) async {
    final prefs = await SharedPreferences.getInstance();
    int verifyKey = _generateRandomNumber();
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
      int verifyKey = _generateRandomNumber();
      logDebug(verifyKey);
      prefs.setString(AuthKeys.kAuthVerifyKey, verifyKey.toString());
      return const Right("Thành công");
    }catch(e){
      return const Left("Thất bại");
    }
  }
}