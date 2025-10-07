import 'package:dartz/dartz.dart';
import 'package:trip_mate/commons/endpoint.dart';
import 'package:trip_mate/core/api_client/api_client.dart';
import 'package:trip_mate/features/security/data/dtos/new_pass_request.dart';

class SecurityApiSource {
  Future<Either> resetPassword(String email) async {
    final apiService = ApiService();
    return apiService.sendRequest(() async {
      final responseData = await apiService.post(
        AppEndPoints.kRequestResetPassword,
        data: {
          "email": email.trim(),
        },
        skipAuth: true,
      );

      if (responseData is Map<String, dynamic>) {
        final message = responseData['message'] as String?;

        return Right(message);
      }
      return const Left("Lỗi định dạng phản hồi từ máy chủ.");
    });
  }

  Future<Either> newPassword(NewPasswordRequest req) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const Right("We've changed your password");
  }
}