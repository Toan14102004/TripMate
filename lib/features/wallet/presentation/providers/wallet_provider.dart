import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/core/app_global.dart';
import 'package:trip_mate/core/ultils/toast_util.dart';
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
    emit(WalletLoading());
    final result = await sl<GetWalletUseCase>().call();

    result.fold(
      (left) {
        ToastUtil.showErrorToast(left);
        emit(WalletError(left));
      },
      (right) {
        emit(WalletData.fromEntity(right));
      },
    );
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

  Future<void> registerNewWallet({required String accountName, required String accountNumber, required String bankName, required String bankCode, required double initialBalance}) async {
     final result = await WalletApiSource.createWallet(accountName: accountName, accountNumber: accountNumber, bankName: bankName);
     result.fold(
      (left) {
        ToastUtil.showErrorToast(left);
        emit(WalletError(left));
      },
      (right) {
        ToastUtil.showSuccessToast(right);
        Navigator.of(AppGlobal.navigatorKey.currentContext!).pushReplacement(
          MaterialPageRoute(builder: (_) => const WalletScreen()),
        );

        ScaffoldMessenger.of(AppGlobal.navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Wallet registered successfully!')),
        );
      },
    );
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
}
