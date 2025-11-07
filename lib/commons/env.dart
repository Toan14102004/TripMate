class Environment {
  static const String kDomain = 'http://192.85.4.249:3000/';
  static const String kFcmAndroidApiKey = String.fromEnvironment('APP_FCM_ANDROID_API_KEY');
  static const String kFcmIosApiKey = String.fromEnvironment('APP_FCM_IOS_API_KEY');
  static const String kFcmSenderId =
      String.fromEnvironment('APP_FCM_SENDER_ID');
  static const String kFcmProjectID =
      String.fromEnvironment('APP_FCM_PROJECT_ID');
  static const String kFcmAndroidAppID =
      String.fromEnvironment('APP_FCM_ANDROID_APP_ID');
  static const String kFcmStorageBucket =
      String.fromEnvironment('APP_FCM_STORAGE_BUCKET');
  static const String kFcmIOSBundleID = String.fromEnvironment('APP_BUNDLE_ID');
  static const String kFcmIOSdAppID =
      String.fromEnvironment('APP_FCM_IOS_APP_ID');
}
