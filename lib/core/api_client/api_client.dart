import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:trip_mate/commons/env.dart';
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/core/ultils/toast_util.dart';
import 'package:trip_mate/services/local_storage/auth.dart';

class ApiService {
  final Dio _dio;

  final Dio _refreshDio; 

  // Constructor
  ApiService({
    String baseUrl = Environment.kDomain,
    Duration connectTimeout = const Duration(seconds: 30),
    Duration receiveTimeout = const Duration(seconds: 30),
  })  : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: connectTimeout,
            receiveTimeout: receiveTimeout,
          ),
        ),
        _refreshDio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: connectTimeout,
            receiveTimeout: receiveTimeout,
          ),
        ) {
    // Chỉ giữ lại Interceptor để LOGGING (Token refresh logic bị loại bỏ khỏi đây)
    if (kDebugMode) {
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            logDebug('REQUEST[${options.method}] => PATH: ${options.path}');
            logDebug('HEADERS: ${options.headers}');
            if (options.data != null) {
              logDebug('DATA: ${options.data}');
            }
            return handler.next(options);
          },
          onResponse: (response, handler) {
            logDebug(
              'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
            );
            return handler.next(response);
          },
          onError: (DioException e, handler) {
            // Logging lỗi vẫn giữ ở đây
            logError(
              'ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}',
            );
            ToastUtil.showErrorToast('MESSAGE: ${e.message}');
            return handler.next(e);
          },
        ),
      );
    }
  }

  // --- HÀM MỚI: LÀM MỚI TOKEN ---
  Future<String?> _performTokenRefresh() async {
    final refreshToken = await AuthRepository.getRefreshToken();

    if (refreshToken == null) {
      logDebug('Refresh Token is missing. Cannot refresh.');
      return null;
    }

    try {
      logDebug('Attempting token refresh...');
      final refreshResponse = await _refreshDio.post(
        '/auth/refresh-token',
        data: {
          "refreshToken": refreshToken,
        },
      );

      final newAccessToken = refreshResponse.data['access_token'];
      final newRefreshToken = refreshResponse.data['refresh_token'];

      if (newAccessToken != null && newRefreshToken != null) {
        await AuthRepository.setAccessToken(newAccessToken);
        await AuthRepository.setRefreshToken(newRefreshToken);
        logDebug('Token refresh successful. New Access Token: $newAccessToken');
        return newAccessToken;
      }
    } on DioException catch (refreshError) {
      logError('Token refresh failed: ${refreshError.message}');
      // Có thể gọi AuthRepository.logout() tại đây nếu refresh thất bại
    } catch (err) {
      logError('Unknown error during token refresh: $err');
    }
    return null;
  }
  // ----------------------------------


  // --- Phương thức hỗ trợ đã được CẬP NHẬT ---
  Future<dynamic> _handleRequest(
    Future<Response> Function(String? token) requestBuilder, {
    bool skipAuth = false,
  }) async {
    // Số lần thử lại tối đa (chỉ thử lại 1 lần sau khi refresh)
    const maxRetries = 1;
    int currentTry = 0;
    
    // Vòng lặp để thực hiện request và thử lại sau khi refresh
    while (currentTry <= maxRetries) {
      currentTry++;
      String? currentToken;

      try {
        if (!skipAuth) {
          currentToken = await AuthRepository.getAccessToken();
        } 
        
        // Gửi request bằng requestBuilder, truyền token
        final response = await requestBuilder(currentToken);
        return response.data;

      } on DioException catch (e) {
        final isUnauthorized = e.response?.statusCode == 401;
        final isUnauthorizedMessage = e.response?.data is Map<String, dynamic> && e.response?.data['message'] == 'Unauthorized';

        // 1. Kiểm tra lỗi 401 và message, và đảm bảo đây là lần thử đầu tiên
        if (!skipAuth && isUnauthorized && isUnauthorizedMessage && currentTry == 1) {
          logDebug('401 Unauthorized detected. Attempting token refresh...');
          
          // 2. Thực hiện làm mới token
          final newToken = await _performTokenRefresh();

          if (newToken != null) {
            // Nếu refresh thành công, set lại maxRetries = 1 để vòng lặp chạy thêm 1 lần nữa
            // Và lặp lại request với token mới
            continue; 
          } else {
            // Nếu refresh thất bại, thoát khỏi vòng lặp và ném lỗi 401 (hoặc lỗi refresh)
            logDebug('Token refresh failed. Throwing original error.');
            // Ném lỗi 401 Unauthorized để app xử lý (ví dụ: chuyển sang màn hình đăng nhập)
            rethrow; 
          }
        } 
        
        // Xử lý các lỗi Dio không liên quan đến token hoặc đã thử lại
        if (e.response != null) {
          throw DioException(
            requestOptions: e.requestOptions,
            response: e.response,
            message: e.response?.data['message'] ?? 'Lỗi từ máy chủ',
          );
        } else {
          throw Exception(
            'Không có kết nối Internet hoặc timeout. Vui lòng thử lại!',
          );
        }
      } catch (e) {
        // Các lỗi khác
        logError(e);
        throw Exception('Đã xảy ra lỗi không xác định: $e');
      }
    }
  }


  Future<Either> sendRequest(
    Future<Either> Function() request) async {
    // ... (Giữ nguyên)
    try {
      return await request();
    } on DioException catch (e) {
      logError(e);
      final errorMessage = e.message ?? 'Đã xảy ra lỗi kết nối mạng.';
      if (e.response?.data is Map<String, dynamic> &&
          e.response?.data['message'] != null) {
        return Left(e.response!.data['message']);
      }

      return Left(errorMessage);
    } catch (e) {
      logError(e);
      final errorMessage =
          e is Exception
              ? e.toString().replaceFirst('Exception: ', '')
              : 'Đã xảy ra lỗi không xác định.';
      return Left(errorMessage);
    }
  }

  // --- API Methods (CẬP NHẬT để sử dụng requestBuilder) ---

  /// GET Request
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool skipAuth = false,
  }) async {
    return _handleRequest(
      (token) => _dio.get(
        path,
        queryParameters: queryParameters,
        options: token != null ? Options(headers: {'Authorization': 'Bearer $token'}) : null,
      ),
      skipAuth: skipAuth,
    );
  }

  /// POST Request
  Future<dynamic> post(
    String path, {
    dynamic data,
    bool skipAuth = false,
  }) async {
    return _handleRequest(
      (token) => _dio.post(
        path,
        data: data,
        options: token != null ? Options(headers: {'Authorization': 'Bearer $token'}) : null,
      ),
      skipAuth: skipAuth,
    );
  }
  
  // ... CẬP NHẬT tương tự cho PUT, DELETE, PATCH ...
  
  /// PUT Request
  Future<dynamic> put(
    String path, {
    dynamic data,
    bool skipAuth = false,
  }) async {
    return _handleRequest(
      (token) => _dio.put(
        path,
        data: data,
        options: token != null ? Options(headers: {'Authorization': 'Bearer $token'}) : null,
      ),
      skipAuth: skipAuth,
    );
  }

  /// DELETE Request
  Future<dynamic> delete(
    String path, {
    dynamic data,
    bool skipAuth = false,
  }) async {
    return _handleRequest(
      (token) => _dio.delete(
        path,
        data: data,
        options: token != null ? Options(headers: {'Authorization': 'Bearer $token'}) : null,
      ),
      skipAuth: skipAuth,
    );
  }

  /// PATCH Request
  Future<dynamic> patch(
    String path, {
    dynamic data,
    bool skipAuth = false,
  }) async {
    return _handleRequest(
      (token) => _dio.patch(
        path,
        data: data,
        options: token != null ? Options(headers: {'Authorization': 'Bearer $token'}) : null,
      ),
      skipAuth: skipAuth,
    );
  }
}