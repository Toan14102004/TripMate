// verification_provider.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_mate/commons/enum/verify_enum.dart';
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/core/app_global.dart';
import 'package:trip_mate/core/ultils/toast_util.dart';
import 'package:trip_mate/features/auth/domain/usecases/resend_token_usecase.dart';
import 'package:trip_mate/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:trip_mate/features/auth/domain/usecases/verify_pass_usecase.dart';
import 'package:trip_mate/features/auth/presentation/providers/verification/verification_state.dart';
import 'package:trip_mate/features/security/domain/usecases/reset_password_usecase.dart';
import 'package:trip_mate/features/security/presentation/providers/new_password/new_password_bloc.dart';
import 'package:trip_mate/service_locator.dart';

class VerificationCubit extends Cubit<VerificationState> {
  VerificationCubit() : super(const VerificationInitial());

  Future<void> verifyCode(String code, VerifyEnum style, String email) async {
    try {
      emit(const VerificationLoading());
      if (style == VerifyEnum.resetPassword) {
        String newPass =
            AppGlobal.navigatorKey.currentContext!
                .read<NewPasswordCubit>()
                .password;
        var result = await sl<VerifyPassUseCase>().call(
          params: {'email': email, 'newPass': newPass, 'token': code},
        );
        result.fold(
          (left) {
            emit(VerificationError(message: left.toString()));
          },
          (right) {
            emit(const VerificationSuccess());
          },
        );
      } else {
        var result = await sl<VerifyEmailUseCase>().call(
          params: {'email': email, 'token': code},
        );
        result.fold(
          (left) {
            emit(VerificationError(message: left.toString()));
          },
          (right) {
            emit(const VerificationSuccess());
          },
        );
      }
    } catch (e) {
      emit(VerificationError(message: 'Verification failed: ${e.toString()}'));
    }
  }

  Future<void> resendCode(String email, VerifyEnum style) async {
    try {
      emit(const VerificationLoading());

      if (style == VerifyEnum.resetPassword) {
        final result = await sl<ResetPassUseCase>().call(params: email);
        result.fold(
          (left) {
            ToastUtil.showErrorToast(left.toString(), title: "Error");
            emit(const VerificationCodeResent());
          },
          (right) {
            ToastUtil.showSuccessToast(right.toString(), title: "Success");
            emit(const VerificationCodeResent());
          },
        );
      } else {
        final result = await sl<ResendTokenUsecase>().call(params: email);
        result.fold(
          (left) {
            ToastUtil.showErrorToast(left.toString(), title: "Error");
            emit(const VerificationCodeResent());
          },
          (right) {
            ToastUtil.showSuccessToast(right.toString(), title: "Success");
            emit(const VerificationCodeResent());
          },
        );
      }
      emit(const VerificationInitial());
    } catch (e) {
      emit(
        VerificationError(message: 'Failed to resend code: ${e.toString()}'),
      );
    }
  }
}
