import 'package:equatable/equatable.dart';
import 'package:trip_mate/features/profile/domain/entities/profile_entity.dart';

class ProfileState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class ProfileData extends ProfileState {
  final String fullname;
  final DateTime dob;
  final String email;
  final String userName;
  final String phoneNumber;
  final String address;
  final String role;
  @override
  List<Object?> get props => [fullname, dob, email, userName, phoneNumber, address, role];

  ProfileData({
    required this.email,
    required this.dob,
    required this.fullname,
    required this.address,
    required this.phoneNumber,
    required this.role,
    required this.userName,
  });

  ProfileEntity convertToEntity() {
    return ProfileEntity(
      email: email,
      dob: dob,
      fullname: fullname,
      userName: userName,
      phoneNumber: phoneNumber,
      address: address,
      role: role,
    );
  }

  ProfileData copyWith({
    String? fullname, 
    DateTime? dob, 
    String? email,
    DateTime? birthDay,
    String? userName,
    String? phoneNumber,
    String? address,
    String? role
  }) {
    return ProfileData(
      email: email ?? this.email,
      dob: dob ?? this.dob,
      fullname: fullname ?? this.fullname, 
      address: address ?? this.address, 
      phoneNumber: phoneNumber ?? this.phoneNumber, 
      role: role ?? this.role, 
      userName: userName ?? this.userName
    );
  }
}

class ProfileLoading extends ProfileState {}

// ignore: must_be_immutable
class ProfileError extends ProfileState {
  String message;
  ProfileError({required this.message});
  @override
  List<Object?> get props => [message];
}
