class AppEndPoints {
  // Route names
  static const String kRegister = '/auth/Register';
  static const String kRequestResetPassword = '/auth/request-password-reset';
  static const String kLogin = '/auth/Login';
  static const String kProfile = '/auth/Profile';
  static const String kResetPass = '/auth/reset-password';
  static const String kRequestVerifyRegisterOTP =
      '/auth/request-verify-user-register-otp';
  static const String kVerifyRegisterOTP = '/auth/verify-user-register-otp';
  static const String kUpdateUser = '/user/update';
  static const String kSavedTours = '/favourites/FilterPagination';
  static const String kFilterPagination = '/tours/FilterPagination';
  static const String kTourDetail = '/tours';
  static const String kTimelines = '/timelines/FilterPagination';
  static const String kImageFromTour = '/images/TourId';

  static String kTourHashtags = '/tour-hashtags';

  static String kReviews = '/reviews/FilterPagination';

  static String kSubmitReviews = '/reviews';
}
