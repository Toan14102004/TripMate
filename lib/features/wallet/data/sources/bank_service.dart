import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trip_mate/features/wallet/data/dtos/bank_response.dart';
import 'package:trip_mate/features/wallet/domain/entities/bank_model.dart';
// Import model Bank của bạn
// import 'package:trip_mate/features/wallet/data/models/bank_model.dart';

class BankService {
  static const String _baseUrl = 'https://api.vietqr.io/v2/banks';
  
  // Cache để tránh gọi API nhiều lần
  static List<Bank>? _cachedBanks;
  static DateTime? _cacheTime;
  static const Duration _cacheDuration = Duration(hours: 24);

  /// Lấy danh sách tất cả ngân hàng
  Future<List<Bank>> fetchBanks({bool forceRefresh = false}) async {
    // Kiểm tra cache
    if (!forceRefresh && _cachedBanks != null && _cacheTime != null) {
      final cacheAge = DateTime.now().difference(_cacheTime!);
      if (cacheAge < _cacheDuration) {
        return _cachedBanks!;
      }
    }

    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Connection timeout. Please check your internet connection.');
        },
      );
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        final bankResponse = BankListResponse.fromJson(jsonData);
        
        // Lưu vào cache
        _cachedBanks = bankResponse.data;
        _cacheTime = DateTime.now();
        
        return bankResponse.data;
      } else if (response.statusCode == 404) {
        throw Exception('API endpoint not found');
      } else if (response.statusCode >= 500) {
        throw Exception('Server error. Please try again later.');
      } else {
        throw Exception('Failed to load banks: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } on FormatException catch (e) {
      throw Exception('Invalid data format: ${e.message}');
    } catch (e) {
      if (e.toString().contains('timeout')) {
        throw Exception('Connection timeout. Please check your internet connection.');
      }
      throw Exception('Error fetching banks: $e');
    }
  }

  /// Tìm ngân hàng theo mã code
  Future<Bank?> getBankByCode(String code) async {
    try {
      final banks = await fetchBanks();
      return banks.firstWhere(
        (bank) => bank.code.toLowerCase() == code.toLowerCase(),
        orElse: () => throw Exception('Bank not found'),
      );
    } catch (e) {
      return null;
    }
  }

  /// Tìm ngân hàng theo bin
  Future<Bank?> getBankByBin(String bin) async {
    try {
      final banks = await fetchBanks();
      return banks.firstWhere(
        (bank) => bank.bin == bin,
        orElse: () => throw Exception('Bank not found'),
      );
    } catch (e) {
      return null;
    }
  }

  /// Tìm kiếm ngân hàng theo keyword
  Future<List<Bank>> searchBanks(String keyword) async {
    try {
      final banks = await fetchBanks();
      final lowerKeyword = keyword.toLowerCase();
      
      return banks.where((bank) {
        return bank.name.toLowerCase().contains(lowerKeyword) ||
            bank.shortName.toLowerCase().contains(lowerKeyword) ||
            bank.code.toLowerCase().contains(lowerKeyword);
      }).toList();
    } catch (e) {
      throw Exception('Error searching banks: $e');
    }
  }

  /// Lọc ngân hàng hỗ trợ chuyển khoản
  Future<List<Bank>> getTransferSupportedBanks() async {
    try {
      final banks = await fetchBanks();
      return banks.where((bank) => bank.transferSupported == 1).toList();
    } catch (e) {
      throw Exception('Error filtering banks: $e');
    }
  }

  /// Lọc ngân hàng hỗ trợ tra cứu
  Future<List<Bank>> getLookupSupportedBanks() async {
    try {
      final banks = await fetchBanks();
      return banks.where((bank) => bank.lookupSupported == 1).toList();
    } catch (e) {
      throw Exception('Error filtering banks: $e');
    }
  }

  /// Xóa cache (dùng khi cần refresh dữ liệu)
  void clearCache() {
    _cachedBanks = null;
    _cacheTime = null;
  }

  /// Kiểm tra xem cache còn hợp lệ không
  bool isCacheValid() {
    if (_cachedBanks == null || _cacheTime == null) {
      return false;
    }
    final cacheAge = DateTime.now().difference(_cacheTime!);
    return cacheAge < _cacheDuration;
  }

  /// Lấy số lượng ngân hàng từ cache
  int? getCachedBankCount() {
    return _cachedBanks?.length;
  }
}