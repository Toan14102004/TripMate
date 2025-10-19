class UserModel {
  final int userId;
  final String? googleId;
  final String fullName;
  final String userName;
  final String email;
  final String? avatar;
  final String phoneNumber;
  final String address;
  final DateTime birthDay;
  final String isActive;
  final String role;

  UserModel({
    required this.userId,
    this.googleId,
    required this.fullName,
    required this.userName,
    required this.email,
    this.avatar,
    required this.phoneNumber,
    required this.address,
    required this.birthDay,
    required this.isActive,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Hàm trợ giúp để xử lý các giá trị có thể là null, int, hoặc string,
    // và trả về chuỗi (hoặc ném lỗi nếu là trường required)
    String _safeString(
      dynamic value, {
      bool required = true,
      String defaultValue = '',
    }) {
      if (value is String) return value;
      if (value == null) {
        if (required) {
          // Ném lỗi nếu giá trị là null và trường này được yêu cầu
          throw const FormatException('Missing required String field.');
        }
        return defaultValue;
      }
      // Nếu là kiểu dữ liệu khác, cố gắng chuyển sang chuỗi (hoặc mặc định)
      return value.toString();
    }

    // Tương tự cho DateTime
    DateTime _safeDateTime(dynamic value) {
      if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
      return DateTime.now();
    }

    return UserModel(
      // 1. Dùng ?? 0 để xử lý null/missing cho required int
      userId: json['userId'] as int? ?? 0,

      // 2. Các trường nullable (String?) chỉ cần as String?
      googleId: json['google_id'] as String?,

      // 3. Các trường non-nullable (String) cần dùng ?? '' (hoặc _safeString)
      fullName: _safeString(json['fullName']),
      userName: _safeString(json['userName']),
      email: _safeString(json['email']),

      // 4. Avatar (nullable String?) có thể là null trong JSON, không cần '??'
      // Lưu ý: Nếu avatar là non-nullable String trong UserModel, hãy dùng ?? ''
      avatar: json['avatar'] as String?,

      // 5. Các trường String non-nullable còn lại
      phoneNumber: _safeString(json['phoneNumber']),
      address: _safeString(json['address']),
      isActive: _safeString(json['isActive']),
      role: _safeString(json['role']),

      // 6. DateTime
      birthDay: _safeDateTime(json['birthDay']),
    );
  }
}
