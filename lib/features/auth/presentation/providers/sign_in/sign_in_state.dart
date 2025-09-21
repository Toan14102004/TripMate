import 'package:equatable/equatable.dart';

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object?> get props => [];
}

class SignInInitial extends SignInState {
  bool isPasswordVisible;
  bool rememberMe;
  String email;
  String password;
  
  SignInInitial({
    required this.isPasswordVisible,
    required this.email,
    required this.password,
    required this.rememberMe
  });  

  SignInInitial copyWith({
    bool? isPasswordVisible,
    bool? rememberMe,
    String? email,
    String? password
  }){
    return SignInInitial(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible, 
      email: email ?? this.email, 
      password: password ?? this.password, 
      rememberMe: rememberMe ?? this.rememberMe
    );
  }
  @override
  List<Object?> get props => [isPasswordVisible, email, password, rememberMe];
}

class SignInLoading extends SignInState {}