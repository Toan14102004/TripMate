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
  final int userId;
  final double latitude;
  final double longitude;

  ProfileEntity({
    required this.userName, 
    required this.phoneNumber, 
    required this.address, 
    required this.role,
    required this.email,
    required this.dob,
    required this.fullname,
    required this.userId,
    required this.latitude,
    required this.longitude
  });

  ProfileData convertToState(){
    return ProfileData(
      email: email, 
      dob: dob, 
      fullname: fullname, 
      address: address, 
      phoneNumber: phoneNumber, 
      role: role, 
      userName: userName,
      userId: userId,
      latitude: latitude,
      longitude: longitude
    );
  }

  ProfileRequest convertToRequest(){
    return ProfileRequest(
      email: email, 
      fullName: fullname, 
      userId: userId, 
      birthDay: dob, 
      userName: userName, 
      phoneNumber: phoneNumber, 
      address: address, 
      role: role,
      latitude: latitude,
      longitude: longitude
    );
  }
}