import 'package:equatable/equatable.dart';

abstract class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object?> get props => [];
}

class ResetPasswordInitial extends ResetPasswordState{
  String email;
  
  ResetPasswordInitial({
    required this.email,
  });  

  ResetPasswordInitial copyWith({
    String? email,
  }){
    return ResetPasswordInitial(
      email: email ?? this.email, 
    );
  }
  @override
  List<Object?> get props => [email];
}

class ResetPasswordLoading extends ResetPasswordState {}