// sign_in_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_mate/commons/validate.dart';
import 'package:trip_mate/core/app_global.dart';
import 'package:trip_mate/core/ultils/toast_util.dart';
import 'package:trip_mate/features/auth/domain/usecases/signup_usecase.dart';
import 'package:trip_mate/features/auth/presentation/screens/verification_screen.dart';
import 'package:trip_mate/features/security/domain/usecases/reset_password_usecase.dart';
import 'package:trip_mate/features/security/presentation/providers/reset_password/reset_password_state.dart';
import 'package:trip_mate/features/security/presentation/screens/new_password_screen.dart';
import 'package:trip_mate/routes/app_route.dart';
import 'package:trip_mate/service_locator.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial(email: ''));

  void onChangeEmail(String email) {
    if (state is ResetPasswordInitial) {
      final currentState = state as ResetPasswordInitial;
      emit(currentState.copyWith(email: email));
    }
  }

  Future<void> resetPassword() async {
    if (state is ResetPasswordInitial) {
      final currentState = state as ResetPasswordInitial;
      if (currentState.email.isEmpty) {
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

      emit(ResetPasswordLoading());

      try {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));

        final result = await sl<ResetPassUseCase>().call(
          params: currentState.email,
        );

        result.fold(
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
                      navigatorRouterNext:
                          (context) =>
                              NewPasswordScreen(email: currentState.email),
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
    emit(ResetPasswordInitial(email: ''));
  }
}
