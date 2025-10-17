// TODO: Profile 기능에 대한 Response를 정의하세요.
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/features/profile/domain/entities/profile_entity.dart';

class ProfileResponse {
  final String? fullName;
  final String email;
  final int userId;
  final DateTime? birthDay;
  final String? userName;
  final String? phoneNumber;
  final String? address;
  final String? role;
  final double? latitude;
  final double? longitude;

  ProfileResponse({
    required this.email,
    this.birthDay,
    this.fullName,
    this.userName,
    this.phoneNumber,
    this.address,
    this.role,
    this.latitude,
    this.longitude,
    required this.userId,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    final String? birthDayString = json['birthDay'] as String?;
    final DateTime? parsedBirthDay =
        birthDayString != null ? DateTime.tryParse(birthDayString) : null;

    final result = ProfileResponse(
      fullName: json['fullName'] as String?,
      birthDay: parsedBirthDay,
      userName: json['userName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] as String?,
      role: json['role'] as String?,
      latitude: _roundDouble(json['latitude'], 6),
      longitude: _roundDouble(json['longitude'], 6),
      email: (json['email'] as String?) ?? (throw FormatException('Email is required.')),
      userId: (json['userId'] as int?) ?? (throw FormatException('User ID is required.')),
    );
    return result;
  }

  static double? _roundDouble(dynamic value, int places) {
    double? parsedValue;
    if (value is String) {
      parsedValue = double.tryParse(value);
    } else if (value is double) {
      parsedValue = value;
    }

    if (parsedValue == null) return null;

    final factor = 10.0 * places;
    return (parsedValue * factor).round() / factor;
  }

  ProfileEntity convertToEntity() {
    return ProfileEntity(
      email: email,
      dob: birthDay ?? DateTime.now(),
      fullname: fullName ?? 'Unknown',
      userName: userName ?? 'Unknown',
      phoneNumber: phoneNumber ?? 'Unknown',
      address: address ?? 'Unknown',
      role: role ?? 'Unknown',
      userId: userId,
      latitude: latitude ?? 21.028511,
      longitude: longitude ?? 105.804817,
    );
  }
}
