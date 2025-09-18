// verification_provider.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/core/ultils/toast_util.dart';
import 'package:trip_mate/features/auth/domain/usecases/resend_token_usecase.dart';
import 'package:trip_mate/features/auth/domain/usecases/verify_usecase.dart';
import 'package:trip_mate/features/auth/presentation/providers/verification/verification_state.dart';
import 'package:trip_mate/service_locator.dart';

class VerificationCubit extends Cubit<VerificationState> {
  VerificationCubit() : super(const VerificationInitial());

  Future<void> verifyCode(String code) async {
    try {
      emit(const VerificationLoading());     
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      logDebug(code);
      var result = await sl<VerifyUseCase>().call(params: code);
      result.fold((left){
        emit(VerificationError(message: left.toString()));
      }, (right){
        emit(const VerificationSuccess());
      });
    } catch (e) {
      emit(VerificationError(
        message: 'Verification failed: ${e.toString()}',
      ));
    }
  }

  Future<void> resendCode() async {
    try {
      emit(const VerificationLoading());
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final result = await sl<ResendTokenUsecase>().call();

      result.fold(
        (left){
          ToastUtil.showErrorToast(left);
          emit(const VerificationCodeResent());
        },
        (right){
          ToastUtil.showSuccessToast(right);
          emit(const VerificationCodeResent());
        }
      );      
      // Reset to initial state after showing success message
      await Future.delayed(const Duration(milliseconds: 500));
      emit(const VerificationInitial());
      
    } catch (e) {
      emit(VerificationError(
        message: 'Failed to resend code: ${e.toString()}',
      ));
    }
  }
}