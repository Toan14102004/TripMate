// TODO: Profile 기능의 API 소스를 구현하세요.
import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_mate/commons/endpoint.dart';
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/commons/storage_keys/auth.dart';
import 'package:trip_mate/core/api_client/api_client.dart';
import 'package:trip_mate/features/profile/data/dtos/profile_request.dart';
import 'package:trip_mate/features/profile/data/dtos/profile_response.dart';

class ProfileApiSource {
  Future<Either> getProfile() async {
    final apiService = ApiService();
    return apiService.sendRequest(() async {
      final responseData = await apiService.get(
        AppEndPoints.kProfile,
        skipAuth: false,
      );
      logDebug(responseData);
      if (responseData is Map<String, dynamic>) {
        final profileResponse = ProfileResponse.fromJson(responseData);
        return Right(profileResponse.convertToEntity().convertToState());
      }
      return const Left("Lỗi định dạng dữ liệu profile từ máy chủ.");
    });
  }

  Future<Either> updateProfile(ProfileRequest entity) async {
    final apiService = ApiService();
    return apiService.sendRequest(() async {
      final responseData = await apiService.patch(
        '${AppEndPoints.kUpdateUser}/${entity.userId}',
        data: {
          "fullName": entity.fullName,
          "userName": entity.userName,
          "email": entity.email,
          "phoneNumber": entity.phoneNumber,
          "address": entity.address,
          "birthDay": DateFormat('yyyy-MM-dd').format(entity.birthDay),
          "latitude": entity.latitude,
          "longitude": entity.longitude,
        },
        skipAuth: false,
      );
      logDebug(responseData);
      if (responseData is Map<String, dynamic>) {
        final profileResponse = ProfileResponse.fromJson(responseData['data']);
        return Right(profileResponse.convertToEntity().convertToState());
      }
      return const Left("Lỗi định dạng dữ liệu profile từ máy chủ.");
    });
  }

  Future<Either> logout() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.remove(AuthKeys.kEmail);
      pref.remove(AuthKeys.kDob);
      return const Right('Success');
    } catch (e) {
      return const Left('Fail to logout');
    }
  }
}
