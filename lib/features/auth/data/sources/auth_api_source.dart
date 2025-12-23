// TODO: Auth 기능의 API 소스를 구현하세요.
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_mate/commons/endpoint.dart';
import 'package:trip_mate/commons/storage_keys/auth.dart';
import 'package:trip_mate/core/api_client/api_client.dart';
import 'package:trip_mate/features/auth/data/dtos/signin_request.dart';
import 'package:trip_mate/features/auth/data/dtos/signup_request.dart';
import 'package:trip_mate/services/local_storage/auth.dart';

class AuthApiSource {
  Future<Either> signInWithEmailAndPassword(SigninUserReq signInUserReq) async {
    final apiService = ApiService();
    return apiService.sendRequest(() async {
      final responseData = await apiService.post(
        AppEndPoints.kLogin,
        data: {
          "email": signInUserReq.email,
          "password": signInUserReq.password,
        },
        skipAuth: true,
      );

      // Debug log to check API response
      print('Login Response Data: $responseData');

      if (responseData is Map<String, dynamic>) {
        final accessToken = responseData['access_token'] as String?;
        final refreshToken = responseData['refresh_token'] as String?;
        
        // Try to get userId from multiple possible locations in response
        dynamic userId = responseData['userId'] ?? 
                        responseData['user_id'] ?? 
                        responseData['user']?['userId'] ?? 
                        responseData['user']?['user_id'] ??
                        responseData['user']?['id'] ??
                        responseData['id'];

        if (accessToken != null && refreshToken != null) {
          final prefs = await SharedPreferences.getInstance();
          AuthRepository.setAccessToken(accessToken);
          AuthRepository.setRefreshToken(refreshToken);
          prefs.setString(AuthKeys.kEmail, signInUserReq.email);
          
          // Save userId to SharedPreferences
          if (userId != null) {
            prefs.setString(AuthKeys.kUserId, userId.toString());
          } else {
            print('WARNING: userId not found in login response!');
          }

          return const Right("Đăng nhập thành công!");
        } else {
          return const Left("Lỗi server: Không nhận được token.");
        }
      }
      return const Left("Lỗi định dạng phản hồi từ máy chủ.");
    });
  }

  Future<Either> signUpWithEmailAndPassword(CreateUserReq createUserReq) async {
    final apiService = ApiService();
    return apiService.sendRequest(() async {
      final responseData = await apiService.post(
        AppEndPoints.kRegister,
        data: {
          "fullName": createUserReq.fullName.trim(),
          "email": createUserReq.email.trim(),
          "passWord": createUserReq.password.trim(),
          "phoneNumber": createUserReq.phone.trim(),
          "birthDay": DateFormat('yyyy-MM-dd').format(createUserReq.dob),
        },
        skipAuth: true,
      );

      if (responseData is Map<String, dynamic>) {
        final statusCode = responseData['statusCode'] as int?;
        final message = responseData['message'] as String?;

        if (statusCode == 200) {
          return Right(message);
        } else {
          return Left(message);
        }
      }
      return const Left("Lỗi định dạng phản hồi từ máy chủ.");
    });
  }

  Future<Either> verifyPassToken(
    String token,
    String email,
    String newPass,
  ) async {
    final apiService = ApiService();
    return apiService.sendRequest(() async {
      final responseData = await apiService.post(
        AppEndPoints.kResetPass,
        data: {"email": email, "otp": token, "newPassword": newPass},
        skipAuth: true,
      );

      if (responseData is Map<String, dynamic>) {
        final statusCode = responseData['statusCode'] as int?;
        final message = responseData['message'] as String?;

        if (statusCode == 200 || statusCode == 201 || statusCode == null) {
          return Right(message);
        } else {
          return Left(message);
        }
      }
      return const Left("Lỗi định dạng phản hồi từ máy chủ.");
    });
  }

  Future<Either> verifyEmailToken(String token, String email) async {
    final apiService = ApiService();
    return apiService.sendRequest(() async {
      final responseData = await apiService.post(
        AppEndPoints.kVerifyRegisterOTP,
        data: {
          "email": email.trim(),
          "otp": token
        },
        skipAuth: true,
      );

      if (responseData is Map<String, dynamic>) {
        final statusCode = responseData['statusCode'] as int?;
        final message = responseData['message'] as String?;

        if (statusCode == 200 || statusCode == 201 || statusCode == null) {
          return Right(message);
        } else {
          return Left(message);
        }
      }
      return const Left("Lỗi định dạng phản hồi từ máy chủ.");
    });
  }

  Future<Either> resendToken(String email) async {
    final apiService = ApiService();
    return apiService.sendRequest(() async {
      final responseData = await apiService.post(
        AppEndPoints.kRequestVerifyRegisterOTP,
        data: {"email": email},
        skipAuth: true,
      );

      if (responseData is Map<String, dynamic>) {
        final statusCode = responseData['statusCode'] as int?;
        final message = responseData['message'] as String?;

        if (statusCode == 200 || statusCode == 201 || statusCode == null) {
          return Right(message);
        } else {
          return Left(message);
        }
      }
      return const Left("Lỗi định dạng phản hồi từ máy chủ.");
    });
  }
}
