// // TODO: Home 기능의 API 소스를 구현하세요.
// import 'package:dio/dio.dart';
// import 'package:trip_mate/features/home/domain/models/tour_model.dart';

// class HomeApiSource {
//   final Dio _dio = Dio();

//   // Lấy danh sách tất cả tour/packages
//   Future<List<TourModel>> fetchAllPackages() async {
//     final response = await _dio.get('https://api-url.com/api/tours');
//     // Parse response về List<TourModel>
//     // return List<TourModel>.from(response.data.map((e) => TourModel.fromJson(e)));
//     // Nếu chưa có API thật, trả về mock data
//     throw UnimplementedError();
//   }

//   // Lấy danh sách popular packages
//   Future<List<TourModel>> fetchPopularPackages() async {
//     final response = await _dio.get('https://api-url.com/api/tours/popular');
//     throw UnimplementedError();
//   }

//   // Lấy danh sách top packages
//   Future<List<TourModel>> fetchTopPackages() async {
//     final response = await _dio.get('https://api-url.com/api/tours/top');
//     throw UnimplementedError();
//   }

//   // Lấy chi tiết một tour/package
//   Future<TourModel> fetchPackageDetail(int tourId) async {
//     final response = await _dio.get('https://api-url.com/api/tours/$tourId');
//     throw UnimplementedError();
//   }
// Future<String> fetchUserAvatarUrl() async {
// Gọi API lấy thông tin user
// final response = await http.get(Uri.parse('https://api.com/user/profile'));
// final data = jsonDecode(response.body);
// return data['avatarUrl'];
// Demo: trả về link avatar mẫu
// return 'https://yourapi.com/path/to/avatar.jpg';
// }
// }

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:trip_mate/commons/endpoint.dart';
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/core/api_client/api_client.dart';
import 'package:trip_mate/core/ultils/toast_util.dart';
import 'package:trip_mate/features/home/domain/models/image_model.dart';
import 'package:trip_mate/features/home/domain/models/time_line_item.dart';
import 'package:trip_mate/features/home/domain/models/tour_detail_model.dart';
import 'package:trip_mate/features/home/domain/models/tour_model.dart';

class HomeApiSource {
  // Lấy danh sách tất cả tour/packages
  Future<List<TourModel>> fetchAllPackages() async {
    final apiService = ApiService();
    final result = await apiService.sendRequest(() async {
      final responseData = await apiService.get(
        AppEndPoints.kFilterPagination,
        queryParameters: {'orderBy': 'newest', 'status': 'active', 'limit': 4, 'page': 1},
        skipAuth: true,
      );

      if (responseData is Map<String, dynamic>) {
        final statusCode = responseData['statusCode'] as int?;
        final message = responseData['message'] as String?;
        if (statusCode == 200) {
          final List<dynamic> rawTours = responseData['data']['tours'];

          List<TourModel> data =
              rawTours.map((e) => TourModel.fromJson(e)).toList();

          return Right(data);
        } else {
          return Left("Lỗi server: $message");
        }
      }
      return const Left("Lỗi định dạng phản hồi từ máy chủ.");
    });

    return result.fold(
      (l) {
        ToastUtil.showErrorToast(l.toString());
        return [];
      },
      (r) {
        return r;
      },
    );
  }

  // Lấy danh sách popular packages
  Future<List<TourModel>> fetchPopularPackages() async {
    final apiService = ApiService();
    final result = await apiService.sendRequest(() async {
      final responseData = await apiService.get(
        AppEndPoints.kFilterPagination,
        queryParameters: {'orderBy': 'booking', 'status': 'active', 'limit': 4, 'page': 1},
        skipAuth: true,
      );

      if (responseData is Map<String, dynamic>) {
        final statusCode = responseData['statusCode'] as int?;
        final message = responseData['message'] as String?;
        if (statusCode == 200) {
          final List<dynamic> rawTours = responseData['data']['tours'];

          List<TourModel> data =
              rawTours.map((e) => TourModel.fromJson(e)).toList();

          return Right(data);
        } else {
          return Left("Lỗi server: $message");
        }
      }
      return const Left("Lỗi định dạng phản hồi từ máy chủ.");
    });

    return result.fold(
      (l) {
        ToastUtil.showErrorToast(l.toString());
        return [];
      },
      (r) {
        return r;
      },
    );
  }

  // Lấy danh sách top packages
  Future<List<TourModel>> fetchTopPackages() async {
    final apiService = ApiService();
    final result = await apiService.sendRequest(() async {
      final responseData = await apiService.get(
        AppEndPoints.kFilterPagination,
        queryParameters: {'orderBy': 'rating', 'status': 'active', 'limit': 4, 'page': 1},
        skipAuth: true,
      );

      if (responseData is Map<String, dynamic>) {
        final statusCode = responseData['statusCode'] as int?;
        final message = responseData['message'] as String?;
        if (statusCode == 200) {
          final List<dynamic> rawTours = responseData['data']['tours'];

          List<TourModel> data =
              rawTours.map((e) => TourModel.fromJson(e)).toList();

          return Right(data);
        } else {
          return Left("Lỗi server: $message");
        }
      }
      return const Left("Lỗi định dạng phản hồi từ máy chủ.");
    });

    return result.fold(
      (l) {
        ToastUtil.showErrorToast(l.toString());
        return [];
      },
      (r) {
        return r;
      },
    );
  }

  // Lấy chi tiết một tour/package
  Future<TourModel> fetchPackageDetail(int tourId) async {
    return TourModel(
      tourId: tourId,
      title: 'The Lind Boracay Resort',
      description:
          'The Lind Boracay resort has its own train station and can be reached from either lau spezia or levantonipo. From la spezia, take the local train trendo regionale in the direction of sestrin levante and get off at the first stop. From levanto, take the regional train in direction of la spezia centrale.',
      image: 'assets/images/lind_boracay.png',
      destination: 'East Evritania, Singapore',
      rating: 4.8,
      reviewCount: 8400,
      price: 520,
      subtitle: '2 days 3 night full package',
      isBookmarked: false,
    );
  }

  Future<String> fetchUserAvatarUrl() async {
    // Trả về ảnh
    return 'assets/images/avatar.png';
  }

  Future<TourDetailModel> getTourDetail(int tourId) async {
    final apiService = ApiService();
    final tourResult = await apiService.sendRequest(() async {
      final responseData = await apiService.get(
        '${AppEndPoints.kTourDetail}/$tourId',
        skipAuth: true,
      );

      if (responseData is Map<String, dynamic>) {
        if (responseData['statusCode'] == 200 && responseData['data'] != null) {
          logDebug(responseData['data']);
          final TourDetailModel tourModel = TourDetailModel.fromTourJson(
            responseData['data'],
          );
          return Right(tourModel);
        } else {
          return Left("Lỗi server tour: ${responseData['message']}");
        }
      }
      return const Left("Lỗi định dạng phản hồi Tour.");
    });

    final TourDetailModel tourModel = tourResult.fold((l) {
      ToastUtil.showErrorToast(l.toString());
      throw Exception(l);
    }, (r) => r);

    final timelineResult = await apiService.sendRequest(() async {
      final responseData = await apiService.get(
        AppEndPoints.kTimelines,
        queryParameters: {'tourId': tourId.toString(), 'page': 1, 'limit': 10},
        skipAuth: true,
      );

      if (responseData is Map<String, dynamic>) {
        if (responseData['statusCode'] == 200 &&
            responseData['data']?['timelines'] != null) {
          final List<dynamic> rawTimelines = responseData['data']['timelines'];
          final List<TimelineItem> timelines =
              rawTimelines
                  .map((e) => TimelineItem.fromJson(e as Map<String, dynamic>))
                  .toList();
          return Right(timelines);
        } else {
          return const Right(<TimelineItem>[]);
        }
      }
      return const Right(
        <TimelineItem>[],
      ); 
    });

    final List<TimelineItem> timelines = timelineResult.fold((l) {
      ToastUtil.showWarningToast("Không thể tải timeline: $l");
      return [];
    }, (r) => r);

    final imagesResult = await apiService.sendRequest(() async {
      final responseData = await apiService.get(
        '${AppEndPoints.kImageFromTour}/$tourId',
        skipAuth: true,
      );

      if (responseData is Map<String, dynamic>) {
        if (responseData['statusCode'] == 200 &&
            responseData['data'] != null) {
          final List<dynamic> rawImages = responseData['data'];
          final List<ImageModel> images =
              rawImages
                  .map((e) => ImageModel.fromJson(e as Map<String, dynamic>))
                  .toList();
          return Right(images);
        } else {
          return const Right(<ImageModel>[]);
        }
      }
      return const Right(
        <ImageModel>[],
      ); 
    });

    final List<ImageModel> images = imagesResult.fold((l) {
      ToastUtil.showWarningToast("Không thể tải timeline: $l");
      return [];
    }, (r) => r);

    logDebug(images.map((e) => e.imageURL).toList());

    return tourModel.copyWith(timelines: timelines, images: images);
  }
}
