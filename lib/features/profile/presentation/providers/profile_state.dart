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
  @override
  // TODO: implement props
  List<Object?> get props => [fullname, dob, email];

  ProfileData({required this.email, required this.dob, required this.fullname});

  ProfileEntity convertToEntity() {
    return ProfileEntity(email: email, dob: dob, fullname: fullname);
  }

  ProfileData copyWith({String? fullname, DateTime? dob, String? email}) {
    return ProfileData(
      email: email ?? this.email,
      dob: dob ?? this.dob,
      fullname: fullname ?? this.fullname,
    );
  }
}

class ProfileLoading extends ProfileState {}

// ignore: must_be_immutable
class ProfileError extends ProfileState {
  String message;
  ProfileError({required this.message});
  List<Object?> get props => [message];
}
