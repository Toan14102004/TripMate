// TODO: Profile 기능에 대한 Response를 정의하세요.
import 'package:trip_mate/features/profile/domain/entities/profile_entity.dart';

class ProfileResponse {
  final String? fullName;
  final String email;
  final DateTime? birthDay;
  final String? userName;
  final String? phoneNumber;
  final String? address;
  final String? role;

  ProfileResponse({
    required this.email,
    this.birthDay,
    this.fullName,
    this.userName,
    this.phoneNumber,
    this.address,
    this.role,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    final String? birthDayString = json['birthDay'] as String?;
    final DateTime? parsedBirthDay = birthDayString != null
        ? DateTime.tryParse(birthDayString)
        : null;

    return ProfileResponse(
      fullName: json['fullName'] as String?,
      email: json['email'] as String,
      birthDay: parsedBirthDay,
      userName: json['userName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] as String?,
      role: json['role'] as String?,
    );
  }

  ProfileEntity convertToEntity(){
    return ProfileEntity(
      email: email, 
      dob: birthDay ?? DateTime.now(),
      fullname: fullName ?? 'Unknown', 
      userName: userName ?? 'Unknown', 
      phoneNumber: phoneNumber ?? 'Unknown', 
      address: address ?? 'Unknown', 
      role: role ?? 'Unknown',
    );
  }
}