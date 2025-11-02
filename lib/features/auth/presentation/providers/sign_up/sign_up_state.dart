import 'package:equatable/equatable.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object?> get props => [];
}

class SignUpInitial extends SignUpState {
  bool isPasswordVisible;
  bool isConfirmPasswordVisible;
  String email;
  String password;
  String phone;
  DateTime birthDay;
  String name;
  
  SignUpInitial({
    required this.isPasswordVisible,
    required this.isConfirmPasswordVisible,
    required this.email,
    required this.password,
    required this.birthDay,
    required this.name,
    required this.phone
  });  

  SignUpInitial copyWith({
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    String? email,
    DateTime? birthDay,
    String? password,
    String? name,
    String? phone
  }){
    return SignUpInitial(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible, 
      email: email ?? this.email, 
      birthDay: birthDay ?? this.birthDay,
      password: password ?? this.password, 
      isConfirmPasswordVisible: isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      name: name ?? this.name,
      phone: phone ?? this.phone
    );
  }
  @override
  List<Object?> get props => [isConfirmPasswordVisible, isPasswordVisible, email, password, birthDay];
}

class SignUpLoading extends SignUpState {}
