import 'package:dartz/dartz.dart';
import 'package:trip_mate/commons/endpoint.dart';
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/core/api_client/api_client.dart';
import 'package:trip_mate/core/ultils/toast_util.dart';
import 'package:trip_mate/features/home/domain/models/hashtag_model.dart';
import 'package:trip_mate/features/home/domain/models/image_model.dart';
import 'package:trip_mate/features/home/domain/models/review_model.dart';
import 'package:trip_mate/features/home/domain/models/time_line_item.dart';
import 'package:trip_mate/features/home/domain/models/tour_detail_model.dart';
import 'package:trip_mate/features/home/domain/models/tour_model.dart';

class HomeApiSource {
  final ApiService _apiService = ApiService();
  // Lấy danh sách tất cả tour/packages
  Future<Map<String, dynamic>> fetchAllPackages({
    int page = 1,
    int limit = 4,
  }) async {
    final apiService = ApiService();
    final result = await apiService.sendRequest(() async {
      final responseData = await apiService.get(
        AppEndPoints.kFilterPagination,
        queryParameters: {'orderBy': 'newest', 'status': 'active', 'limit': limit, 'page': page},
        skipAuth: true,
      );

      if (responseData is Map<String, dynamic>) {
        final statusCode = responseData['statusCode'] as int?;
        final message = responseData['message'] as String?;
        if (statusCode == 200) {
          final List<dynamic> rawTours = responseData['data']['tours'];
          final total = responseData['data']['countTour'];

          List<TourModel> data =
              rawTours.map((e) => TourModel.fromJson(e)).toList();

          return Right({'tours': data, 'total': total});
        } else {
          return Left("Lỗi server: $message");
        }
      }
      return const Left("Lỗi định dạng phản hồi từ máy chủ.");
    });

    return result.fold(
      (l) {
        ToastUtil.showErrorToast(l.toString());
        return {'tours': <TourModel>[], 'total': 0};
      },
      (r) {
        return r;
      },
    );
  }

  // Lấy danh sách popular packages
  Future<Map<String, dynamic>> fetchPopularPackages({
    int page = 1,
    int limit = 6,
  }) async {
    final apiService = ApiService();
    final result = await apiService.sendRequest(() async {
      final responseData = await apiService.get(
        AppEndPoints.kFilterPagination,
        queryParameters: {'orderBy': 'booking', 'status': 'active', 'limit': limit, 'page': page},
        skipAuth: true,
      );

      if (responseData is Map<String, dynamic>) {
        final statusCode = responseData['statusCode'] as int?;
        final message = responseData['message'] as String?;
        if (statusCode == 200) {
          final List<dynamic> rawTours = responseData['data']['tours'];
          final total = responseData['data']['countTour'];

          List<TourModel> data =
              rawTours.map((e) => TourModel.fromJson(e)).toList();

          return Right({'tours': data, 'total': total});
        } else {
          return Left("Lỗi server: $message");
        }
      }
      return const Left("Lỗi định dạng phản hồi từ máy chủ.");
    });

    return result.fold(
      (l) {
        ToastUtil.showErrorToast(l.toString());
        return {'tours': <TourModel>[], 'total': 0};
      },
      (r) {
        return r;
      },
    );
  }

  // Lấy danh sách top packages
  Future<Map<String, dynamic>> fetchTopPackages({
    int page = 1,
    int limit = 6,
  }) async {
    final apiService = ApiService();
    final result = await apiService.sendRequest(() async {
      final responseData = await apiService.get(
        AppEndPoints.kFilterPagination,
        queryParameters: {'orderBy': 'rating', 'status': 'active', 'limit': limit, 'page': page},
        skipAuth: true,
      );

      if (responseData is Map<String, dynamic>) {
        final statusCode = responseData['statusCode'] as int?;
        final message = responseData['message'] as String?;
        if (statusCode == 200) {
          final List<dynamic> rawTours = responseData['data']['tours'];
          final total = responseData['data']['countTour'];

          List<TourModel> data =
              rawTours.map((e) => TourModel.fromJson(e)).toList();

          return Right({'tours': data, 'total': total});
        } else {
          return Left("Lỗi server: $message");
        }
      }
      return const Left("Lỗi định dạng phản hồi từ máy chủ.");
    });

    return result.fold(
      (l) {
        ToastUtil.showErrorToast(l.toString());
        return {'tours': <TourModel>[], 'total': 0};
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

  // =========================================================================
  // CÁC PHƯƠNG THỨC MỚI CHO TOUR DETAIL
  // =========================================================================

  /// 1. Lấy danh sách Hashtag của Tour (GET /tour-hashtags?tourId=...)
  /// Repository gọi: sl<HomeApiSource>().fetchTourHashtags(tourId);
  Future<List<HashtagModel>> fetchTourHashtags(int tourId) async {
    try {
      final responseData = await _apiService.get(
        AppEndPoints.kTourHashtags, // Endpoint: /tour-hashtags
        queryParameters: {'tourId': tourId}, // Filter theo tourId
        skipAuth: true, // Thường không cần Auth cho dữ liệu công khai
      );

      // Giả sử API trả về List trực tiếp, hoặc trong field 'data'
      final listData = responseData is Map && responseData.containsKey('data')
          ? responseData['data']
          : responseData;

      if (listData is List) {
        return listData
            .map((json) => HashtagModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        // Xử lý trường hợp format response không mong muốn
        logError('Invalid response format for fetchTourHashtags: $responseData');
        return [];
      }
    } catch (e) {
      logError('Error fetching tour hashtags: $e');
      throw Exception('Failed to fetch tour hashtags: $e');
    }
  }

  /// 2. Lấy danh sách Reviews của Tour (GET /reviews?tourId=...&page=...&limit=...)
  /// Repository gọi: sl<HomeApiSource>().fetchTourReviews(tourId, page: page, limit: limit);
  Future<List<ReviewModel>> fetchTourReviews(
    int tourId, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final responseData = await _apiService.get(
        AppEndPoints.kReviews, // Endpoint: /reviews
        queryParameters: {
          'tourId': tourId,
          'page': page,
          'limit': limit,
        },
        skipAuth: true, // Thường không cần Auth cho dữ liệu công khai
      );

      // Giả sử API trả về một Map<String, dynamic> với key 'data' chứa List<ReviewModel>
      final listData = responseData is Map && responseData.containsKey('data')
          ? responseData['data']
          : responseData;

      if (listData is List) {
        return listData
            .map((json) => ReviewModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        logError('Invalid response format for fetchTourReviews: $responseData');
        return [];
      }
    } catch (e) {
      logError('Error fetching tour reviews: $e');
      throw Exception('Failed to fetch tour reviews: $e');
    }
  }

  /// 3. Gửi Review (POST /reviews)
  /// Repository gọi: sl<HomeApiSource>().submitReview(...);
  Future<ReviewModel> submitReview({
    required int tourId,
    required int userId, // Giả sử userId được truyền vào hoặc lấy từ session trong repo
    required int rating,
    String? comment,
  }) async {
    try {
      final data = {
        'tourId': tourId,
        'userId': userId,
        'rating': rating,
        if (comment != null && comment.isNotEmpty) 'comment': comment,
      };

      final responseData = await _apiService.post(
        AppEndPoints.kSubmitReviews, // Endpoint: /reviews
        data: data,
        skipAuth: false, // Yêu cầu xác thực (Bearer Auth)
      );

      // Giả sử API trả về ReviewModel đã tạo thành công
      final reviewJson = responseData is Map && responseData.containsKey('data')
          ? responseData['data']
          : responseData;

      if (reviewJson is Map<String, dynamic>) {
        // Show Toast thông báo thành công
        ToastUtil.showSuccessToast('Gửi đánh giá thành công!');
        return ReviewModel.fromJson(reviewJson);
      } else {
       logError('Invalid response format for submitReview: $responseData');
        throw Exception('Failed to parse submitted review response');
      }
    } catch (e) {
      logError('Gửi đánh giá thất bại. Vui lòng thử lại.');
      throw Exception('Failed to submit review: $e');
    }
  }
}
