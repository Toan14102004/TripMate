// sign_in_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_mate/commons/enum/verify_enum.dart';
import 'package:trip_mate/commons/validate.dart';
import 'package:trip_mate/core/app_global.dart';
import 'package:trip_mate/core/ultils/toast_util.dart';
import 'package:trip_mate/features/auth/presentation/screens/signin_screen.dart';
import 'package:trip_mate/features/auth/presentation/screens/verification_email_screen.dart';
import 'package:trip_mate/features/security/domain/usecases/reset_password_usecase.dart';
import 'package:trip_mate/features/security/presentation/providers/new_password/new_password_state.dart';
import 'package:trip_mate/service_locator.dart';

class NewPasswordCubit extends Cubit<NewPasswordState> {
  NewPasswordCubit()
    : super(NewPasswordInitial(email: '', confirmPassword: '', password: '', isSuccess: false));

  String password = '';

  void onChangeConfirmPassword(String confirmPassword) {
    if (state is NewPasswordInitial) {
      final currentState = state as NewPasswordInitial;
      emit(currentState.copyWith(confirmPassword: confirmPassword));
    }
  }

  void onChangePassword(String password) {
    if (state is NewPasswordInitial) {
      final currentState = state as NewPasswordInitial;
      this.password = password;
      emit(currentState.copyWith(password: password));
    }
  }

  void onChangeEmail(String email) {
    if (state is NewPasswordInitial) {
      final currentState = state as NewPasswordInitial;
      emit(currentState.copyWith(email: email));
    }
  }

  Future<void> newPassword() async {
    if (state is NewPasswordInitial) {
      final currentState = state as NewPasswordInitial;
      if (currentState.email.isEmpty || currentState.confirmPassword.isEmpty || currentState.password.isEmpty) {
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

      if (currentState.confirmPassword != currentState.password) {
        ToastUtil.showErrorToast(
          title: "Error",
          'Passwords do not match',
        );
        return;
      }

      emit(NewPasswordLoading());

      try {
        final result1 = await sl<ResetPassUseCase>().call(
          params: currentState.email,
        );

        result1.fold(
          (left) {
            ToastUtil.showErrorToast(title: "Error", left);
            emit(currentState);
          },
          (right) {
            ToastUtil.showSuccessToast(title: "Success", right);
            Navigator.of(AppGlobal.navigatorKey.currentContext!).push(
              MaterialPageRoute(
                builder:
                    (context) => VerificationScreen(
                      email: currentState.email,
                      styleEnum: VerifyEnum.resetPassword,
                      navigatorRouterNext:
                          (context) => const SignInScreen(),
                    ),
              ),
            );
            emit(currentState);
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

  void resetState() {
    if (state is NewPasswordInitial) {
      final currentState = state as NewPasswordInitial;
      emit(NewPasswordInitial(email: currentState.email, confirmPassword: '', password: '', isSuccess: false));
    }
  }
}
