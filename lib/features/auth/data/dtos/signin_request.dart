class SigninUserReq {
  final bool rememberMe;
  final String email;
  final String password;

  SigninUserReq({
    required this.email,
    required this.password,
    required this.rememberMe
  });
}
