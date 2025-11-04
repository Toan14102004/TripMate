// Thêm các methods này vào HomeApiSource hoặc BookingApiSource

import 'package:dartz/dartz.dart';
import 'package:trip_mate/commons/endpoint.dart';
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/core/api_client/api_client.dart';
import 'package:trip_mate/core/ultils/toast_util.dart';
import 'package:trip_mate/features/booking/domain/entities/start_end_date_model.dart';

// 1. Fetch Start-End Dates với pagination và filter
Future<Map<String, dynamic>> fetchStartEndDates({
  required int page,
  required int limit,
  String? tourId,
  double? minPriceAdult,
  double? maxPriceAdult,
  double? minPriceChildren,
  double? maxPriceChildren,
}) async {
  final apiService = ApiService();
  final result = await apiService.sendRequest(() async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    
    if (tourId != null) queryParams['tourId'] = tourId;
    if (minPriceAdult != null) queryParams['minpriceAdult'] = minPriceAdult;
    if (maxPriceAdult != null) queryParams['maxpriceAdult'] = maxPriceAdult;
    if (minPriceChildren != null) queryParams['minpriceChildren'] = minPriceChildren;
    if (maxPriceChildren != null) queryParams['maxpriceChildren'] = maxPriceChildren;
    
    final responseData = await apiService.get(
      AppEndPoints.kStartEndDatesFilterPagination,
      queryParameters: queryParams,
      skipAuth: true,
    );

    if (responseData is Map<String, dynamic>) {
      final statusCode = responseData['statusCode'] as int?;
      final message = responseData['message'] as String?;
      
      if (statusCode == 200) {
        final List<dynamic> rawDates = responseData['data']['startEndDates'] ?? [];
        final total = responseData['data']['total'] ?? 0;
        logDebug(rawDates);
        List<StartEndDateModel> dates =
            rawDates.map((e) => StartEndDateModel.fromJson(e)).toList();

        return Right({'dates': dates, 'total': total});
      } else {
        return Left("Lỗi server: $message");
      }
    }
    return const Left("Lỗi định dạng phản hồi từ máy chủ.");
  });

  return result.fold(
    (l) {
      ToastUtil.showErrorToast(l.toString());
      return {'dates': <StartEndDateModel>[], 'total': 0};
    },
    (r) {
      return r;
    },
  );
}

Future<Map<String, dynamic>> createBooking({
  required int tourId,
  required int userId,
  required int dateId,
  required String fullName,
  required String email,
  required String phoneNumber,
  String? address,
  required int numAdults,
  int numChildren = 0,
  required double totalPrice,
  String bookingStatus = 'pending',
  bool receiveEmail = true,
}) async {
  final apiService = ApiService();
  final result = await apiService.sendRequest(() async {
    final requestBody = {
      'tourId': tourId,
      'userId': userId,
      'dateId': dateId,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      if (address != null && address.isNotEmpty) 'address': address,
      'numAdults': numAdults,
      'numChildren': numChildren,
      'totalPrice': totalPrice,
      'bookingStatus': bookingStatus,
      'receiveEmail': receiveEmail,
    };
    
    final responseData = await apiService.post(
      AppEndPoints.kBookings,
      data: requestBody,
      skipAuth: false,
    );

    if (responseData is Map<String, dynamic>) {
      final statusCode = responseData['statusCode'] as int?;
      final message = responseData['message'] as String?;
      
      if (statusCode == 201 || statusCode == 200) {
        final bookingData = responseData['data'];
        
        return Right({
          'success': true,
          'booking': bookingData,
          'message': message ?? 'Đặt tour thành công!',
        });
      } else {
        return Left("Lỗi server: $message");
      }
    }
    return const Left("Lỗi định dạng phản hồi từ máy chủ.");
  });

  return result.fold(
    (l) {
      ToastUtil.showErrorToast(l.toString());
      return {
        'success': false,
        'message': l.toString(),
      };
    },
    (r) {
      return r;
    },
  );
}