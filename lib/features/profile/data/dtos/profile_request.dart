// TODO: Profile 기능에 대한 Request를 정의하세요.
class ProfileRequest {
  final String fullName;
  final String email;
  final int userId;
  final DateTime birthDay;
  final String userName;
  final String phoneNumber;
  final String address;
  final String role;
  final double latitude;
  final double longitude;

  ProfileRequest({
    required this.email,
    required this.fullName,
    required this.userId, 
    required this.birthDay, 
    required this.userName, 
    required this.phoneNumber, 
    required this.address, 
    required this.role,
    required this.latitude,
    required this.longitude
  });
}
