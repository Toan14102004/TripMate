import 'package:dartz/dartz.dart';
import 'package:trip_mate/features/wallet/domain/entities/wallet_entity.dart';
import 'package:trip_mate/features/wallet/data/dtos/wallet_request.dart';

abstract class WalletRepository {
  Future<Either> getWallet();
  Future<Either> depositMoney(WalletRequest request);
}
