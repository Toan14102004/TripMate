// TODO: Profile 기능에 대한 Request를 정의하세요.
class ProfileRequest {
  final String fullname;
  final DateTime dob;
  final String email;

  ProfileRequest({
    required this.email,
    required this.dob,
    required this.fullname
  });
}