// sign_in_cubit.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_mate/commons/validate.dart';
import 'package:trip_mate/core/app_global.dart';
import 'package:trip_mate/core/ultils/toast_util.dart';
import 'package:trip_mate/features/auth/data/dtos/signin_request.dart';
import 'package:trip_mate/features/auth/domain/usecases/signin_usecase.dart';
import 'package:trip_mate/features/auth/presentation/providers/sign_in/sign_in_state.dart';
import 'package:trip_mate/routes/app_route.dart';
import 'package:trip_mate/service_locator.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit()
    : super(
        SignInInitial(
          isPasswordVisible: false,
          email: '',
          password: '',
          rememberMe: false,
        ),
      );

  void togglePasswordVisibility(bool value) {
    if (state is SignInInitial) {
      final currentState = state as SignInInitial;
      emit(
        currentState.copyWith(
          isPasswordVisible: !currentState.isPasswordVisible,
        ),
      );
    }
  }

  void toggleRememberMe(bool value) {
    if (state is SignInInitial) {
      final currentState = state as SignInInitial;
      emit(currentState.copyWith(rememberMe: !currentState.rememberMe));
    }
  }

  void onChangedEmail(String email) {
    if (state is SignInInitial) {
      final currentState = state as SignInInitial;
      emit(currentState.copyWith(email: email));
    }
  }

  void onChangedPass(String password) {
    if (state is SignInInitial) {
      final currentState = state as SignInInitial;
      emit(currentState.copyWith(password: password));
    }
  }

  Future<void> signIn() async {
    if (state is SignInInitial) {
      final currentState = state as SignInInitial;
      if (currentState.email.isEmpty || currentState.password.isEmpty) {
        ToastUtil.showErrorToast(
          title: "Error",
          'Vui lòng nhập đầy đủ thông tin',
        );
        return;
      }

      if (!Validate.isValidEmail(currentState.email)) {
        ToastUtil.showErrorToast(title: "Error", 'Email không hợp lệ');
        return;
      }

      emit(SignInLoading());

      try {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));

        final result = await sl<SignInUseCase>().call(
          params: SigninUserReq(
            email: currentState.email,
            password: currentState.password,
            rememberMe: currentState.rememberMe,
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
            comeToMainPage();
          },
        );
      } catch (e) {
        ToastUtil.showErrorToast(
          title: "Error",
          'Đã xảy ra lỗi: ${e.toString()}',
        );
        emit(currentState);
      }
    }
  }

  Future<void> signInWithGoogle() async {
    emit(SignInLoading());
    try {
      // Simulate Google Sign In
      await Future.delayed(const Duration(seconds: 1));
      ToastUtil.showSuccessToast(
        title: "Success",
        'Đăng nhập Google thành công!',
      );
      comeToMainPage();
    } catch (e) {
      ToastUtil.showErrorToast(
        title: "Error",
        'Đăng nhập Google thất bại: ${e.toString()}',
      );
      resetState();
    }
  }

  Future<void> signInWithFacebook() async {
    emit(SignInLoading());
    try {
      // Simulate Facebook Sign In
      await Future.delayed(const Duration(seconds: 1));
      ToastUtil.showSuccessToast(
        title: "Success",
        'Đăng nhập Facebook thành công!',
      );
      comeToMainPage();
    } catch (e) {
      ToastUtil.showErrorToast(
        title: "Error",
        'Đăng nhập Facebook thất bại: ${e.toString()}',
      );
      resetState();
    }
  }

  Future<void> signInWithApple() async {
    emit(SignInLoading());
    try {
      // Simulate Apple Sign In
      await Future.delayed(const Duration(seconds: 1));
      ToastUtil.showSuccessToast(
        title: "Success",
        'Đăng nhập Apple thành công!',
      );
      comeToMainPage();
    } catch (e) {
      ToastUtil.showErrorToast(
        title: "Error",
        'Đăng nhập Apple thất bại: ${e.toString()}',
      );
      resetState();
    }
  }

  void comeToMainPage(){
    Navigator.of(AppGlobal.navigatorKey.currentContext!).pushReplacementNamed(AppRoutes.rootPage);
  }

  void resetState() {
    emit(
      SignInInitial(
        isPasswordVisible: false,
        email: '',
        password: '',
        rememberMe: false,
      ),
    );
  }
}
