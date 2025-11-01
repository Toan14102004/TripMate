import 'package:dartz/dartz.dart';
import 'package:trip_mate/features/wallet/data/dtos/wallet_request.dart';
import 'package:trip_mate/features/wallet/data/sources/wallet_api_source.dart';
import 'package:trip_mate/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:trip_mate/service_locator.dart';

class WalletRepositoryImpl implements WalletRepository {
  @override
  Future<Either> getWallet() async {
    return await sl<WalletApiSource>().getWallet();
  }

  @override
  Future<Either> depositMoney(WalletRequest request) async {
    return await sl<WalletApiSource>().depositMoney(request);
  }
}
