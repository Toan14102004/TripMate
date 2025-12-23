import 'package:dartz/dartz.dart';
import 'package:trip_mate/commons/endpoint.dart';
import 'package:trip_mate/core/api_client/api_client.dart';
import 'package:trip_mate/features/wallet/data/dtos/wallet_request.dart';

class WalletApiSource {
  /// Get wallet information
  /// Returns Either<String, Map<String, dynamic>> - Left: error message, Right: wallet data
  Future<Either> getWallet() async {
    final apiService = ApiService();
    
    return apiService.sendRequest(() async {
      final responseData = await apiService.get(
        AppEndPoints.kGetWallet,
        queryParameters: {'limit': '10', 'page': '1'},
      );

      if (responseData is Map<String, dynamic>) {
        final statusCode = responseData['statusCode'] as int?;
        final message = responseData['message'] as String?;

        if (statusCode == 200) {
          final data = responseData['data'] as Map<String, dynamic>?;
          if (data != null) {
            return Right(data);
          }
        }
        return Left(message ?? 'Có lỗi xảy ra khi lấy thông tin ví');
      }

      return const Left('Lỗi định dạng phản hồi từ máy chủ');
    });
  }

  /// Deposit money to wallet
  /// Returns Either - Left: error message, Right: success message
  Future<Either> depositMoney(WalletRequest request) async {
    final apiService = ApiService();
    
    return apiService.sendRequest(() async {
      final responseData = await apiService.post(
        AppEndPoints.kCreateWallet,
        data: request.toMap(),
      );

      if (responseData is Map<String, dynamic>) {
        final statusCode = responseData['statusCode'] as int?;
        final message = responseData['message'] as String?;

        if (statusCode == 200 || statusCode == 201) {
          return Right(message ?? 'Nạp tiền thành công!');
        } else {
          return Left(message ?? 'Có lỗi xảy ra khi nạp tiền');
        }
      }

      return const Left('Lỗi định dạng phản hồi từ máy chủ');
    });
  }

  /// Withdraw money from wallet
  /// Returns Either - Left: error message, Right: success message
  Future<Either> withdrawMoney({
    required int userWalletAccountId,
    required double amount,
  }) async {
    final apiService = ApiService();
    
    return apiService.sendRequest(() async {
      final responseData = await apiService.post(
        AppEndPoints.kWithdraw,
        data: {
          "userWalletAccountId": userWalletAccountId,
          "amount": amount,
          "type": "RUT_TIEN",
        },
      );

      if (responseData is Map<String, dynamic>) {
        final statusCode = responseData['statusCode'] as int?;
        final message = responseData['message'] as String?;

        if (statusCode == 200 || statusCode == 201) {
          return Right(message ?? 'Rút tiền thành công!');
        } else {
          return Left(message ?? 'Có lỗi xảy ra khi rút tiền');
        }
      }

      return const Left('Lỗi định dạng phản hồi từ máy chủ');
    });
  }

  /// Create new wallet
  /// Returns Either - Left: error message, Right: success message
  static Future<Either> createWallet({
    required String accountName,
    required String accountNumber,
    required String bankName,
  }) async {
    final apiService = ApiService();
    
    return apiService.sendRequest(() async {
      final responseData = await apiService.post(
        AppEndPoints.kCreateWallet,
        data: {
          "accountName": accountName,
          "accountNumber": accountNumber,
          "bankName": bankName,
        },
      );

      if (responseData is Map<String, dynamic>) {
        final statusCode = responseData['statusCode'] as int?;
        final message = responseData['message'] as String?;

        if (statusCode == 200 || statusCode == 201) {
          return Right(message ?? 'Tạo ví thành công!');
        } else {
          return Left(message ?? 'Có lỗi xảy ra khi tạo ví');
        }
      }

      return const Left('Lỗi định dạng phản hồi từ máy chủ');
    });
  }

  /// Get history transactions
  /// Returns Map with 'transactions' and 'countTransaction'
  static Future<Map<String, dynamic>> getHistoryTransactions({
    required int currentPage,
    required int limit,
    String? status,
    String? type,
    required int accountId,
  }) async {
    final apiService = ApiService();
    
    try {
      final queryParams = {
        'page': currentPage.toString(),
        'limit': limit.toString(),
        'userWalletAccountId': accountId.toString(),
      };
      
      if (status != null && status.isNotEmpty && status != 'Tất cả') {
        queryParams['status'] = status;
      }
      
      if (type != null && type.isNotEmpty && type != 'Tất cả') {
        queryParams['type'] = type;
      }

      final responseData = await apiService.get(
        AppEndPoints.kTransactions,
        queryParameters: queryParams,
      );

      if (responseData is Map<String, dynamic>) {
        final statusCode = responseData['statusCode'] as int?;
        
        if (statusCode == 200) {
          final data = responseData['data'] as Map<String, dynamic>?;
          if (data != null) {
            return {
              'transactions': data['transactions'] ?? [],
              'countTransaction': data['countTransaction'] ?? 0,
            };
          }
        }
      }

      return {
        'transactions': [],
        'countTransaction': 0,
      };
    } catch (e) {
      return {
        'transactions': [],
        'countTransaction': 0,
      };
    }
  }
}
