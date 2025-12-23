import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/commons/storage_keys/auth.dart';
import 'package:trip_mate/core/app_global.dart';
import 'package:trip_mate/core/ultils/toast_util.dart';
import 'package:trip_mate/features/profile/presentation/providers/profile_bloc.dart';
import 'package:trip_mate/features/profile/presentation/providers/profile_state.dart';
import 'package:trip_mate/features/wallet/data/dtos/wallet_request.dart';
import 'package:trip_mate/features/wallet/data/sources/wallet_api_source.dart';
import 'package:trip_mate/features/wallet/domain/usecases/deposit_money_usecase.dart';
import 'package:trip_mate/features/wallet/domain/usecases/get_wallet_usecase.dart';
import 'package:trip_mate/features/wallet/presentation/providers/wallet_state.dart';
import 'package:trip_mate/features/wallet/presentation/screens/wallet_screen.dart';
import 'package:trip_mate/service_locator.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit() : super(WalletInitial());

  Future<void> initialize() async {
    try {
      logDebug('🔍 WalletCubit: Starting initialize...');
      emit(WalletLoading());
      
      final result = await sl<GetWalletUseCase>().call();

      result.fold(
        (left) {
          logDebug('❤️ WalletCubit: Error - $left');
          ToastUtil.showErrorToast(left);
          emit(WalletError(left));
        },
        (right) {
          logDebug('💚 WalletCubit: Success - emitting WalletData');
          emit(WalletData.fromEntity(right));
        },
      );
    } catch (e) {
      logDebug('❤️ WalletCubit: Exception - $e');
      ToastUtil.showErrorToast('Lỗi: ${e.toString()}');
      emit(WalletError('Lỗi: ${e.toString()}'));
    }
  }

  Future<void> depositMoney(double amount) async {
    if (state is! WalletData) return;
    
    final currentState = state as WalletData;
    emit(WalletLoading());

    final request = WalletRequest(
      accountNumber: currentState.accountNumber,
      amount: amount,
    );

    final result = await sl<DepositMoneyUseCase>().call(request);

    result.fold(
      (left) {
        ToastUtil.showErrorToast(left);
        emit(WalletError(left));
      },
      (right) {
        emit(WalletData.fromEntity(right));
        ToastUtil.showSuccessToast('Nạp tiền thành công');
      },
    );
  }

  // Get current user ID from SharedPreferences (same as HomeApiSource)
  Future<int> _getCurrentUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userIdString = prefs.getString(AuthKeys.kUserId);
      
      logDebug('💚 Getting userId from SharedPreferences: $userIdString');
      
      if (userIdString != null && userIdString.isNotEmpty) {
        final userId = int.tryParse(userIdString);
        if (userId != null && userId != 0) {
          logDebug('💚 Got valid userId from SharedPreferences: $userId');
          return userId;
        }
      }
      
      logDebug('❤️ UserId not found in SharedPreferences');
      return 0;
    } catch (e) {
      logDebug('❤️ Error getting userId from SharedPreferences: $e');
      return 0;
    }
  }

  Future<void> registerNewWallet({required String accountName, required String accountNumber, required String bankName, required String bankCode, required double initialBalance}) async {
      try {
        logDebug('🔍 Starting registerNewWallet...');
        
        // Get userId from SharedPreferences (same as HomeApiSource)
        final userId = await _getCurrentUserId();
      
        if (userId == 0) {
          logDebug('❤️ userId is 0, cannot create wallet');
          ToastUtil.showErrorToast('Không thể lấy thông tin user. Vui lòng đăng nhập lại.');
          emit(WalletError('Không thể lấy thông tin user'));
          return;
        }

        logDebug('🔍 Creating wallet with userId: $userId');
        
        // Create wallet with userId
        final result = await WalletApiSource.createWallet(
          userId: userId,
          accountName: accountName,
          accountNumber: accountNumber,
          bankName: bankName,
        );
        
        result.fold(
          (left) {
            logDebug('❤️ Create wallet error: $left');
            ToastUtil.showErrorToast(left);
            emit(WalletError(left));
          },
          (right) {
            logDebug('💚 Create wallet success: $right');
            ToastUtil.showSuccessToast(right);
            Navigator.of(AppGlobal.navigatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(builder: (_) => const WalletScreen()),
            );

            ScaffoldMessenger.of(AppGlobal.navigatorKey.currentContext!).showSnackBar(
              const SnackBar(content: Text('Wallet registered successfully!')),
            );
          },
        );
      } catch (e) {
        logDebug('❤️ Exception in registerNewWallet: $e');
        ToastUtil.showErrorToast('Lỗi: ${e.toString()}');
        emit(WalletError('Lỗi: ${e.toString()}'));
      }
  }

  Future<double> getUserBalance() async {
    double? _cachedUserId;
    await initialize();
    try {
      final context = AppGlobal.navigatorKey.currentContext!;
      final profileCubit = BlocProvider.of<WalletCubit>(
        context,
        listen: false,
      );

      if (profileCubit.state is WalletData) {
        _cachedUserId = (profileCubit.state as WalletData).balance;
        return _cachedUserId!;
      }

      final dataState =
          await profileCubit.stream
              .where((state) => state is WalletData)
              .cast<WalletData>()
              .first;

      // 3. Lấy userId từ state đã đợi được
      _cachedUserId = dataState.balance;
      return _cachedUserId!;
    } catch (e) {
      logDebug('Error getting userId: $e, using fallback: 1');
      _cachedUserId = 0;
      return _cachedUserId!;
    }
  }

  Future<String> getWalletId() async {
    String? _cachedUserId;
    await initialize();
    try {
      final context = AppGlobal.navigatorKey.currentContext!;
      final profileCubit = BlocProvider.of<WalletCubit>(
        context,
        listen: false,
      );

      if (profileCubit.state is WalletData) {
        _cachedUserId = (profileCubit.state as WalletData).id;
        return _cachedUserId!;
      }

      final dataState =
          await profileCubit.stream
              .where((state) => state is WalletData)
              .cast<WalletData>()
              .first;

      // 3. Lấy userId từ state đã đợi được
      _cachedUserId = dataState.id;
      return _cachedUserId!;
    } catch (e) {
      logDebug('Error getting userId: $e, using fallback: 1');
      _cachedUserId = '0';
      return _cachedUserId!;
    }
  }
}
