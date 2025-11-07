import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_mate/commons/endpoint.dart';
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/core/api_client/api_client.dart';
import 'package:trip_mate/core/app_global.dart';
import 'package:trip_mate/core/ultils/toast_util.dart';
import 'package:trip_mate/features/my_trip/domain/entities/trip.dart';
import 'package:trip_mate/features/profile/presentation/providers/profile_bloc.dart';

import '../dtos/trip_dto.dart';

class MyTripApiService {
  Future<Either> fetchTrips({
    required String userId,
    String bookingStatus = 'pending',
    int page = 1,
    int limit = 4,
  }) async {
    final apiService = ApiService();
    return apiService.sendRequest(() async {
      final responseData = await apiService.get(
        '${AppEndPoints.kMyTripFilterPagination}?userId=$userId&bookingStatus=$bookingStatus&page=$page&limit=$limit',
        skipAuth: true,
      );
      logDebug(
        '${AppEndPoints.kMyTripFilterPagination}?userId=$userId&bookingStatus=$bookingStatus&page=$page&limit=$limit',
      );

      logDebug('MyTrip Response: $responseData');

      if (responseData is Map<String, dynamic>) {
        final statusCode = responseData['statusCode'] as int?;
        if (statusCode == 200 && responseData['data'] != null) {
          // Check if data contains bookings array
          final data = responseData['data'];
          List<dynamic> rawBookings = [];

          if (data is Map<String, dynamic>) {
            rawBookings = data['bookings'] as List<dynamic>? ?? [];
          } else if (data is List) {
            rawBookings = data;
          }

          logDebug('Found ${rawBookings.length} bookings');

          final trips =
              rawBookings
                  .map((e) {
                    try {
                      // If item has tour object, use it
                      final booking = e as Map<String, dynamic>;
                      final tourData = booking;
                      return TripDto.fromJson(tourData);
                    } catch (error) {
                      logDebug('Error parsing booking: $error');
                      return null;
                    }
                  })
                  .where((trip) => trip != null)
                  .cast<TripDto>()
                  .toList();

          return Right(trips);
        } else {
          return Left(
            responseData['message'] ?? 'Lỗi khi lấy danh sách chuyến đi',
          );
        }
      }

      return const Left('Lỗi định dạng dữ liệu từ máy chủ');
    });
  }

  static Future<BookingDetail?> fetchTripsDetail({
    required String bookingId,
  }) async {
    final apiService = ApiService();
    final result = await apiService.sendRequest(() async {
      final responseData = await apiService.get(
        '${AppEndPoints.kBookings}/$bookingId',
        skipAuth: true,
      );

      logDebug('MyTrip Response: $responseData');

      if (responseData is Map<String, dynamic>) {
        final statusCode = responseData['statusCode'] as int?;
        if (statusCode == 200 && responseData['data'] != null) {
          // Check if data contains bookings array
          final data = responseData['data'];
          final bookingDetail = BookingDetail.fromJson(data);
          return Right(bookingDetail);
        } else {
          return Left(
            responseData['message'] ?? 'Lỗi khi lấy chi tiết chuyến đi',
          );
        }
      }

      return const Left('Lỗi định dạng dữ liệu từ máy chủ');
    });

    return result.fold(
      (l) {
        ToastUtil.showErrorToast(l.toString());
        return null;
      },
      (r) {
        return r;
      },
    );
  }

  static Future<void> cancelTripsDetail({required String bookingId}) async {
    final apiService = ApiService();
    final result = await apiService.sendRequest(() async {
      final responseData = await apiService.post(
        '${AppEndPoints.kCancelBookings}/$bookingId',
      );
      logDebug('MyTrip Response: $responseData');

      if (responseData is Map<String, dynamic>) {
        final statusCode = responseData['statusCode'] as int?;
        if (statusCode == 200 && responseData['data'] != null) {
          return const Right('Cancel thành công');
        } else {
          return Left(
            responseData['message'] ?? 'Lỗi khi lấy chi tiết chuyến đi',
          );
        }
      }

      return const Left('Lỗi định dạng dữ liệu từ máy chủ');
    });

    return result.fold(
      (l) {
        ToastUtil.showErrorToast(l.toString());
      },
      (r) {
        ToastUtil.showSuccessToast(r.toString());
      },
    );
  }

  static Future<void> deleteTrips({required String bookingId}) async {
    final apiService = ApiService();
    final result = await apiService.sendRequest(() async {
      final responseData = await apiService.delete(
        '${AppEndPoints.kBookings}/$bookingId',
      );
      logDebug('MyTrip Response: $responseData');

      if (responseData is Map<String, dynamic>) {
        final statusCode = responseData['statusCode'] as int?;
        if (statusCode == 200) {
          return const Right('Cancel thành công');
        } else {
          return Left(
            responseData['message'] ?? 'Lỗi khi lấy chi tiết chuyến đi',
          );
        }
      }

      return const Left('Lỗi định dạng dữ liệu từ máy chủ');
    });

    return result.fold(
      (l) {
        ToastUtil.showErrorToast(l.toString());
      },
      (r) {
        ToastUtil.showSuccessToast(r.toString());
      },
    );
  }

  static Future<void> payCoins({
    required int bookingId,
    required double amount,
  }) async {
    final apiService = ApiService();
    final userId =
        await AppGlobal.navigatorKey.currentContext!
            .read<ProfileCubit>()
            .getUserId();

    final result = await apiService.sendRequest(() async {
      final responseData = await apiService.post(
        AppEndPoints.kPayCoinBooking,
        data: {'bookingId': bookingId, 'amount': amount, 'userId': userId},
      );
      logDebug('MyTrip Response: $responseData');

      if (responseData is Map<String, dynamic>) {
        final statusCode = responseData['statusCode'] as int?;
        if (statusCode == 200 && responseData['data'] != null) {
          return const Right('Chuyển tiền thành công');
        } else {
          return Left(
            responseData['message'] ?? 'Lỗi khi lấy chi tiết chuyến đi',
          );
        }
      }

      return const Left('Lỗi định dạng dữ liệu từ máy chủ');
    });

    result.fold(
      (l) {
        ToastUtil.showErrorToast(l.toString());
      },
      (r) {
        ToastUtil.showSuccessToast(r.toString());
      },
    );
  }
}
