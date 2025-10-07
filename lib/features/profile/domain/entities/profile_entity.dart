// TODO: Profile 기능에 대한 엔티티를 정의하세요.
import 'package:trip_mate/features/profile/data/dtos/profile_request.dart';
import 'package:trip_mate/features/profile/presentation/providers/profile_state.dart';

class ProfileEntity {
  final String fullname;
  final DateTime dob;
  final String email;
  final String userName;
  final String phoneNumber;
  final String address;
  final String role;

  ProfileEntity({
    required this.userName, 
    required this.phoneNumber, 
    required this.address, 
    required this.role,
    required this.email,
    required this.dob,
    required this.fullname
  });

  ProfileData convertToState(){
    return ProfileData(
      email: email, 
      dob: dob, 
      fullname: fullname, 
      address: address, 
      phoneNumber: phoneNumber, 
      role: role, 
      userName: userName
    );
  }

  ProfileRequest convertToRequest(){
    return ProfileRequest(email: email, dob: dob, fullname: fullname);
  }
}