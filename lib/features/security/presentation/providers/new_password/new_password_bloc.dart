// sign_in_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_mate/commons/validate.dart';
import 'package:trip_mate/core/app_global.dart';
import 'package:trip_mate/core/ultils/toast_util.dart';
import 'package:trip_mate/features/auth/presentation/screens/verification_screen.dart';
import 'package:trip_mate/features/security/data/dtos/new_pass_request.dart';
import 'package:trip_mate/features/security/domain/usecases/New_password_usecase.dart';
import 'package:trip_mate/features/security/presentation/providers/new_password/new_password_state.dart';
import 'package:trip_mate/service_locator.dart';

class NewPasswordCubit extends Cubit<NewPasswordState> {
  NewPasswordCubit()
    : super(NewPasswordInitial(email: '', confirmPassword: '', password: '', isSuccess: false));

  void initialCubit(String email) {
    if (state is NewPasswordInitial) {
      final currentState = state as NewPasswordInitial;
      emit(currentState.copyWith(email: email));
    }
  }

  void onChangeConfirmPassword(String confirmPassword) {
    if (state is NewPasswordInitial) {
      final currentState = state as NewPasswordInitial;
      emit(currentState.copyWith(confirmPassword: confirmPassword));
    }
  }

  void onChangePassword(String password) {
    if (state is NewPasswordInitial) {
      final currentState = state as NewPasswordInitial;
      emit(currentState.copyWith(password: password));
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
        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));

        final result = await sl<NewPassUseCase>().call(
          params: NewPasswordRequest(email: currentState.email, password: currentState.password)
        );

        result.fold(
          (left) {
            ToastUtil.showErrorToast(title: "Error", left);
            emit(currentState.copyWith(isSuccess: false));
          },
          (right) {
            ToastUtil.showSuccessToast(title: "Success", right);
            emit(currentState.copyWith(isSuccess: true));
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
