// TODO: Profile 기능의 API 소스를 구현하세요.
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_mate/commons/storage_keys/auth.dart';
import 'package:trip_mate/features/profile/data/dtos/profile_request.dart';
import 'package:trip_mate/features/profile/data/dtos/profile_response.dart';

class ProfileApiSource {
  Future<Either> getProfile() async {
    ProfileResponse response = ProfileResponse(email: '', dob: DateTime.now(), fullname: '');
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString(AuthKeys.kEmail) != null &&
        pref.getString(AuthKeys.kFullName) != null &&
        pref.getString(AuthKeys.kDob) != null) {
      response = ProfileResponse(
        email: pref.getString(AuthKeys.kEmail) ?? '',
        dob: DateTime.parse(
          pref.getString(AuthKeys.kDob) ?? DateTime.now().toIso8601String(),
        ),
        fullname: pref.getString(AuthKeys.kFullName) ?? '',
      );
    } return Right(response.convertToEntity().convertToState());
  }

  Future<Either> updateProfile(ProfileRequest entity) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString(AuthKeys.kEmail, entity.email);
      pref.setString(AuthKeys.kFullName, entity.fullname);
      pref.setString(AuthKeys.kDob, entity.dob.toIso8601String());
      return const Right('Success');
    } catch (e) {
      return const Left('Fail to update profile');
    }
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
