import 'package:dartz/dartz.dart';
import 'package:trip_mate/features/wallet/data/dtos/wallet_request.dart';
import 'package:trip_mate/features/wallet/data/dtos/wallet_response.dart';

class WalletApiSource {
  Future<Either> getWallet() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      
      final response = WalletResponse(
        accountNumber: '1234567890',
        balance: 5250000,
        bankName: 'Vietcombank',
        bankCode: 'VCB',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      );
      
      return Right(response.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either> depositMoney(WalletRequest request) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      
      final response = WalletResponse(
        accountNumber: request.accountNumber,
        balance: 5250000 + request.amount,
        bankName: 'Vietcombank',
        bankCode: 'VCB',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      );
      
      return Right(response.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }
}
