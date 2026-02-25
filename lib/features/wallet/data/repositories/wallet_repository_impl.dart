import 'package:dartz/dartz.dart';
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/features/wallet/data/dtos/wallet_request.dart';
import 'package:trip_mate/features/wallet/data/dtos/wallet_response.dart';
import 'package:trip_mate/features/wallet/data/sources/wallet_api_source.dart';
import 'package:trip_mate/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:trip_mate/service_locator.dart';

class WalletRepositoryImpl implements WalletRepository {
  @override
  Future<Either> getWallet() async {
    try {
      logDebug('🔍 Repository: Getting wallet from API source...');
      final result = await sl<WalletApiSource>().getWallet();
      
      return result.fold(
        (error) {
          logDebug('❤️ Repository: Error from API - $error');
          return Left(error);
        },
        (data) {
          logDebug('💚 Repository: Got data from API - $data');
          try {
            final walletResponse = WalletResponse.fromMap(data as Map<String, dynamic>);
            final walletEntity = walletResponse.toEntity();
            logDebug('💚 Repository: Successfully parsed to entity');
            return Right(walletEntity);
          } catch (e) {
            logDebug('❤️ Repository: Error parsing data - $e');
            return Left('Lỗi parse dữ liệu: ${e.toString()}');
          }
        },
      );
    } catch (e) {
      logDebug('❤️ Repository: Exception - $e');
      return Left('Lỗi: ${e.toString()}');
    }
  }

  @override
  Future<Either> depositMoney(WalletRequest request) async {
    return await sl<WalletApiSource>().depositMoney(request);
  }
}
