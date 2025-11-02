import 'package:dartz/dartz.dart';
import 'package:trip_mate/features/wallet/data/dtos/wallet_request.dart';
import 'package:trip_mate/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:trip_mate/service_locator.dart';

class DepositMoneyUseCase {
  Future<Either> call(WalletRequest request) async {
    return await sl<WalletRepository>().depositMoney(request);
  }
}
