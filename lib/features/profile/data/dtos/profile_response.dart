// TODO: Profile 기능에 대한 Response를 정의하세요.
import 'package:trip_mate/features/profile/domain/entities/profile_entity.dart';

class ProfileResponse {
  final String fullname;
  final DateTime dob;
  final String email;

  ProfileResponse({
    required this.email,
    required this.dob,
    required this.fullname
  });

  ProfileEntity convertToEntity(){
    return ProfileEntity(email: email, dob: dob, fullname: fullname);
  }
}