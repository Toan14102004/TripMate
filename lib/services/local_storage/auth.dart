import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trip_mate/commons/storage_keys/auth.dart';

class AuthRepository {
  // Tạo một instance của FlutterSecureStorage
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Khóa (key) để lưu token
  static const String _kAuthTokenKey = AuthKeys.kAuthTokenKey;
  // Khóa (key) để lưu token

  // --- Các phương thức để thao tác với token ---

  /// Lấy token JWT từ bộ nhớ bảo mật.
  /// Trả về null nếu token không tồn tại.
  static Future<String?> getAuthToken() async {
    return await _storage.read(key: _kAuthTokenKey);
  }

  /// Lưu token JWT vào bộ nhớ bảo mật.
  static Future<void> setAuthToken(String token) async {
    await _storage.write(key: _kAuthTokenKey, value: token);
  }

  /// Xóa token JWT khỏi bộ nhớ bảo mật.
  static Future<void> clearAuthToken() async {
    await _storage.delete(key: _kAuthTokenKey);
  }

  static const String _kUserInfoKey = 'user_info';

  /// Lưu thông tin user (dạng JSON) vào bộ nhớ bảo mật.
  static Future<void> setUserInfo(String userInfoJson) async {
    await _storage.write(key: _kUserInfoKey, value: userInfoJson);
  }

  /// Lấy thông tin user (dạng JSON) từ bộ nhớ bảo mật.
  /// Trả về null nếu chưa lưu thông tin user.
  static Future<String?> getUserInfo() async {
    return await _storage.read(key: _kUserInfoKey);
  }

  /// Xóa thông tin user khỏi bộ nhớ bảo mật.
  static Future<void> clearUserInfo() async {
    await _storage.delete(key: _kUserInfoKey);
  }
}