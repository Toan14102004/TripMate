// sign_in_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_mate/core/app_global.dart';
import 'package:trip_mate/core/ultils/toast_util.dart';
import 'package:trip_mate/features/auth/data/dtos/signup_request.dart';
import 'package:trip_mate/features/auth/domain/usecases/signup_usecase.dart';
import 'package:trip_mate/features/auth/presentation/providers/sign_up/sign_up_state.dart';
import 'package:trip_mate/routes/app_route.dart';
import 'package:trip_mate/service_locator.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial(
    isPasswordVisible: false, 
    email: '', 
    password: '', 
    isConfirmPasswordVisible: false, 
    name: '',
    birthDay: DateTime.now()
  ));

  void togglePasswordVisibility(bool value) {
    if(state is SignUpInitial){
      final currentState = state as SignUpInitial;
      emit(currentState.copyWith(isPasswordVisible: value));
    }
  }

  void toggleConfirmPasswordVisiblity(bool value) {
    if(state is SignUpInitial){
      final currentState = state as SignUpInitial;
      emit(currentState.copyWith(isConfirmPasswordVisible: value));
    }
  }

  void onChangedEmail(String email) {
    if(state is SignUpInitial){
      final currentState = state as SignUpInitial;
      emit(currentState.copyWith(email: email));
    }
  }

  void onChangedName(String name) {
    if(state is SignUpInitial){
      final currentState = state as SignUpInitial;
      emit(currentState.copyWith(name: name));
    }
  }

  void onChangedPass(String password) {
    if(state is SignUpInitial){
      final currentState = state as SignUpInitial;
      emit(currentState.copyWith(password: password));
    }
  }

  void onChangedDob(DateTime dob){
    if(state is SignUpInitial){
      final currentState = state as SignUpInitial;
      emit(currentState.copyWith(birthDay: dob));
    }
  }

  Future<void> SignUp() async {
    if(state is SignUpInitial){
      final currentState = state as SignUpInitial;
      if (currentState.email.isEmpty || currentState.password.isEmpty) {
        ToastUtil.showErrorToast(title: "Error", 'Vui lòng nhập đầy đủ thông tin');
        return;
      }

      if (!_isValidEmail(currentState.email)) {
        ToastUtil.showErrorToast(title: "Error", 'Email không hợp lệ');
        return;
      }

      emit(SignUpLoading());

      try {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));
        
        final result = await sl<SignUpUseCase>().call(
          params: CreateUserReq(
            email: currentState.email,
            password: currentState.password,
            dob: currentState.birthDay, 
            fullName: currentState.name
          ),
        );

        result.fold(
          (left) {
            ToastUtil.showErrorToast(
              title: "Error",
              left,
            );
            emit(currentState);
          },
          (right) {
            ToastUtil.showSuccessToast(title: "Success", right);
            Navigator.of(AppGlobal.navigatorKey.currentContext!).pushNamed(AppRoutes.verification, arguments: currentState.email);
          },
        );
      } catch (e) {
        ToastUtil.showErrorToast(title: "Error", 'Đã xảy ra lỗi: ${e.toString()}');
        emit(currentState);
      }
    }
  }

  Future<void> SignUpWithGoogle() async {
    emit(SignUpLoading());
    try {
      // Simulate Google Sign In
      await Future.delayed(const Duration(seconds: 1));
      ToastUtil.showSuccessToast(title: "Success", 'Đăng nhập Google thành công!');
    } catch (e) {
      ToastUtil.showErrorToast(title: "Error", 'Đăng nhập Google thất bại: ${e.toString()}');
      resetState();
    }
  }

  Future<void> SignUpWithFacebook() async {
    emit(SignUpLoading());
    try {
      // Simulate Facebook Sign In
      await Future.delayed(const Duration(seconds: 1));
      ToastUtil.showSuccessToast(title: "Success", 'Đăng nhập Facebook thành công!');
    } catch (e) {
      ToastUtil.showErrorToast(title: "Error", 'Đăng nhập Facebook thất bại: ${e.toString()}');
      resetState();
    }
  }

  Future<void> SignUpWithApple() async {
    emit(SignUpLoading());
    try {
      // Simulate Apple Sign In
      await Future.delayed(const Duration(seconds: 1));
      ToastUtil.showSuccessToast(title: "Success", 'Đăng nhập Apple thành công!');
    } catch (e) {
      ToastUtil.showErrorToast(title: "Error", 'Đăng nhập Apple thất bại: ${e.toString()}');
      resetState();
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void resetState() {
    emit(SignUpInitial(
      isPasswordVisible: false, 
      email: '', 
      password: '', 
      isConfirmPasswordVisible: false, 
      name: '', 
      birthDay: DateTime.now()
    ));
  }
}
