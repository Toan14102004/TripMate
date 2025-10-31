import 'package:equatable/equatable.dart';

abstract class NewPasswordState extends Equatable {
  const NewPasswordState();

  @override
  List<Object?> get props => [];
}

// ignore: must_be_immutable
class NewPasswordInitial extends NewPasswordState{
  String email;
  String password;
  String confirmPassword;
  bool isSuccess;

  
  NewPasswordInitial({
    required this.email,
    required this.confirmPassword,
    required this.password,
    required this.isSuccess
  });  

  NewPasswordInitial copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    bool? isSuccess
  }){
    return NewPasswordInitial(
      email: email ?? this.email, 
      confirmPassword: confirmPassword ?? this.confirmPassword, 
      password: password ?? this.password, 
      isSuccess: isSuccess ?? this.isSuccess
    );
  }
  @override
  List<Object?> get props => [email, confirmPassword, password, isSuccess];
}

class NewPasswordLoading extends NewPasswordState {}
