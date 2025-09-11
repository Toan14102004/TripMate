import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:trip_mate/commons/env.dart';
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/core/ultils/toast_util.dart';
import 'package:trip_mate/services/local_storage/auth.dart';

class ApiService {
  final Dio _dio;

  // Constructor
  ApiService({
    String baseUrl = Environment.kDomain, 
    Duration connectTimeout = const Duration(seconds: 30),
    Duration receiveTimeout = const Duration(seconds: 30),
  }) : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: connectTimeout,
          receiveTimeout: receiveTimeout,
        )) {
    // Thêm interceptor để log các request/response
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
            logDebug('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
            return handler.next(response);
          },
          onError: (DioException e, handler) {
            logError('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
            ToastUtil.showErrorToast('MESSAGE: ${e.message}');
            return handler.next(e);
          },
        ),
      );
    }
  }

  // --- Các phương thức hỗ trợ ---

  Future<dynamic> _handleRequest(
    Future<Response> Function() request, {
    bool skipAuth = false,
  }) async {
    try {
      if (!skipAuth) {
        // Lấy token
        String? token = await AuthRepository.getAuthToken();
        if (token != null) {
          _dio.options.headers['Authorization'] = 'Bearer $token';
        }
      } else {
        // Nếu skipAuth là true, đảm bảo không có Authorization header
        _dio.options.headers.remove('Authorization');
      }

      final response = await request();
      return response.data;
    } on DioException catch (e) {
      // Xử lý các lỗi Dio
      if (e.response != null) {
        // Lỗi từ server (4xx, 5xx)
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          message: e.response?.data['message'] ?? 'Lỗi từ máy chủ',
        );
      } else {
        // Lỗi kết nối
        throw Exception('Không có kết nối Internet hoặc timeout. Vui lòng thử lại!');
      }
    } catch (e) {
      // Các lỗi khác
      throw Exception('Đã xảy ra lỗi không xác định: $e');
    }
  }

  // --- API Methods ---

  /// GET Request
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool skipAuth = false,
  }) async {
    return _handleRequest(
      () => _dio.get(path, queryParameters: queryParameters),
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
      () => _dio.post(path, data: data),
      skipAuth: skipAuth,
    );
  }

  /// PUT Request
  Future<dynamic> put(
    String path, {
    dynamic data,
    bool skipAuth = false,
  }) async {
    return _handleRequest(
      () => _dio.put(path, data: data),
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
      () => _dio.delete(path, data: data),
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
      () => _dio.patch(path, data: data),
      skipAuth: skipAuth,
    );
  }
}