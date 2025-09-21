import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  // Tạo một instance của FlutterSecureStorage
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Khóa (key) để lưu token
  static const String _kAuthTokenKey = 'authToken';

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
}