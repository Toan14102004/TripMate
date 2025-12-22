import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_mate/commons/endpoint.dart';
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/core/api_client/api_client.dart';
import 'package:trip_mate/core/app_global.dart';
import 'package:trip_mate/core/ultils/toast_util.dart';
import 'package:trip_mate/features/profile/presentation/providers/profile_bloc.dart';
import 'package:trip_mate/features/wallet/data/dtos/wallet_request.dart';
import 'package:trip_mate/features/wallet/data/dtos/wallet_response.dart';

class WalletApiSource {
  Future<Either> getWallet() async {
    final apiService = ApiService();
    String userId =
        await AppGlobal.navigatorKey.currentContext!
            .read<ProfileCubit>()
            .getUserId();
    return await apiService.sendRequest(() async {
      final responseData = await apiService.get(
        '${AppEndPoints.kGetWallet}?status=active&userId=$userId&limit=10&page=1',
      );
      logDebug('MyWallet Response: $responseData');

      if (responseData is Map<String, dynamic>) {
        final statusCode = responseData['statusCode'] as int?;
        if (statusCode == 200 && responseData['data'] != null) {
          final data = responseData['data'];
          List<dynamic> raw = [];

          if (data is Map<String, dynamic>) {
            raw = data['accounts'] as List<dynamic>? ?? [];
          } else if (data is List) {
            raw = data;
          }

          final wallet =
              raw
                  .map((e) {
                    try {
                      final booking = e as Map<String, dynamic>;
                      final tourData = booking;
                      return WalletResponse.fromMap(tourData);
                    } catch (error) {
                      logDebug('Error parsing booking: $error');
                      return null;
                    }
                  })
                  .where((trip) => trip != null)
                  .cast<WalletResponse>()
                  .toList();
          if (wallet.isEmpty) return const Left("Wallet not found");
          return Right(wallet.first.toEntity());
        } else {
          return Left(
            responseData['message'] ?? 'Lỗi khi lấy chi tiết chuyến đi',
          );
        }
      }

      return const Left('Lỗi định dạng dữ liệu từ máy chủ');
    });
  }

  static Future<Either> createWallet({
    required String accountName, 
    required String accountNumber, 
    required String bankName, 
  }) async {
    final apiService = ApiService();
    String userId =
        await AppGlobal.navigatorKey.currentContext!
            .read<ProfileCubit>()
            .getUserId();
    return await apiService.sendRequest(() async {
      final responseData = await apiService.post(
        AppEndPoints.kCreateWallet,
        data: {
          "userId": userId,
          "accountNumber": accountNumber,
          "bankName": bankName,
          "accountName": accountName,
        },
        skipAuth: false,
      );
      logDebug('MyWallet Response: $responseData');

      if (responseData is Map<String, dynamic>) {
        final statusCode = responseData['statusCode'] as int?;
        if (statusCode == 200 && responseData['data'] != null) {
          return Right(responseData['message'] ?? 'Tạo tài khoản thành công');
        } else {
          return Left(
            responseData['message'] ?? 'Lỗi khi lấy chi tiết chuyến đi',
          );
        }
      }

      return const Left('Lỗi định dạng dữ liệu từ máy chủ');
    });
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
        id: '',
        accountName: '',
      );

      return Right(response.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

  static Future<Map<String, dynamic>> getHistoryTransactions({
    int? currentPage,
    int? limit,
    String? status,
    String? type,
    String? accountId,
  }) async {
    final apiService = ApiService();
    final result = await apiService.sendRequest(() async {
      final responseData = await apiService.get(
        AppEndPoints
            .kTransactions,
        queryParameters: {
          'page': currentPage,
          'limit': limit,
          'status': status,
          'type': type,
          'accountId': accountId,
        },
        skipAuth: true,
      );
      logDebug('MyWallet Response: $responseData');

      if (responseData is Map<String, dynamic>) {
        final statusCode = responseData['statusCode'] as int?;
        if (statusCode == 200 && responseData['data'] != null) {
          final data = responseData['data'];
          if (data is Map<String, dynamic>) {
            return Right(
              data,
            ); // Trả về Map chứa 'transactions' và 'countTransaction'
          } else {
            return const Left(
              'Dữ liệu lịch sử giao dịch không đúng định dạng.',
            );
          }
        } else {
          return Left(
            responseData['message'] ?? 'Lỗi khi lấy chi tiết chuyến đi',
          );
        }
      }

      return const Left('Lỗi định dạng dữ liệu từ máy chủ');
    });

    return result.fold(
      (left) {
        ToastUtil.showErrorToast(left.toString());
        return {"transactions": [], "countTransaction": 0};
      },
      (right) {
        return right is Map<String, dynamic>
            ? right
            : {"transactions": [], "countTransaction": 0};
      },
    );
  }
}
