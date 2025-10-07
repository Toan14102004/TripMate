// TODO: Profile 기능에 대한 Provider를 구현하세요.import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_mate/core/app_global.dart';
import 'package:trip_mate/core/ultils/toast_util.dart';
import 'package:trip_mate/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:trip_mate/features/profile/domain/usecases/logout_profile_usercase.dart';
import 'package:trip_mate/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:trip_mate/features/profile/presentation/providers/profile_state.dart';
import 'package:trip_mate/features/splash/presentation/screens/splash_screen.dart';
import 'package:trip_mate/service_locator.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit()
    : super(
        ProfileData(
          fullname: '',
          dob: DateTime.now(),
          email: '',
          address: '',
          phoneNumber: '',
          role: '',
          userName: '',
        ),
      );
  Future<void> initialize() async {
    emit(ProfileLoading());
    final result = await sl<GetProfileUseCase>().call();

    result.fold(
      (left) {
        ToastUtil.showErrorToast(left);
        emit(ProfileError(message: left));
      },
      (right) {
        emit(right as ProfileData);
      },
    );
  }

  Future<void> onChangeProfile({
    String? fullname,
    DateTime? dob,
    String? email,
    DateTime? birthDay,
    String? userName,
    String? phoneNumber,
    String? address,
    String? role,
  }) async {
    if (state is ProfileData) {
      final currentState = state as ProfileData;
      emit(
        currentState.copyWith(
          fullname: fullname,
          dob: dob,
          email: email,
          birthDay: birthDay,
          userName: userName,
          phoneNumber: phoneNumber,
          address: address,
          role: role,
        ),
      );
    }
  }

  Future<void> updateProfile(ProfileData data) async {
    emit(ProfileLoading());
    final result = await sl<UpdateProfileUseCase>().call(params: data);
    result.fold(
      (left) {
        ToastUtil.showErrorToast(left);
        emit(ProfileError(message: left));
      },
      (right) {
        emit(data);
      },
    );
  }

  Future<void> logout() async {
    final result = await sl<LogoutProfileUseCase>().call();
    result.fold(
      (left) {
        ToastUtil.showErrorToast(left);
        emit(ProfileError(message: left));
      },
      (right) {
        ToastUtil.showSuccessToast(right);
        Navigator.of(AppGlobal.navigatorKey.currentContext!).pop();
        Navigator.of(AppGlobal.navigatorKey.currentContext!).pushReplacement(
          MaterialPageRoute(builder: (context) => const TravelSplashScreen()),
        );
        emit(
          ProfileData(
            fullname: '',
            dob: DateTime.now(),
            email: '',
            address: '',
            phoneNumber: '',
            role: '',
            userName: '',
          ),
        );
      },
    );
  }
}
