import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_mate/core/ultils/toast_util.dart';
import 'package:trip_mate/features/wallet/data/dtos/wallet_request.dart';
import 'package:trip_mate/features/wallet/domain/usecases/deposit_money_usecase.dart';
import 'package:trip_mate/features/wallet/domain/usecases/get_wallet_usecase.dart';
import 'package:trip_mate/features/wallet/presentation/providers/wallet_state.dart';
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
}
