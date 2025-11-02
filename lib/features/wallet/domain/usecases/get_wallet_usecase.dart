import 'package:dartz/dartz.dart';
import 'package:trip_mate/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:trip_mate/service_locator.dart';

class GetWalletUseCase {
  Future<Either> call() async {
    return await sl<WalletRepository>().getWallet();
  }
}
