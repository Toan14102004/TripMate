import 'package:flutter/material.dart';
import 'package:trip_mate/features/auth/presentation/screens/signin_screen.dart';
import 'package:trip_mate/features/auth/presentation/screens/signup_screen.dart';
import 'package:trip_mate/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:trip_mate/features/root/presentation/screens/root_screen.dart';
import 'package:trip_mate/features/security/presentation/screens/new_password_screen.dart';
import 'package:trip_mate/features/security/presentation/screens/reset_password_screen.dart';
class AppRoutes {
  // Khai báo tên các route dưới dạng hằng số
  static const String onBoarding = '/onboarding';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String resetPassword = '/reset-password';
  static const String newPassword = '/new-password';
  static const String rootPage = '/root-page';
  // onGenerateRoute dùng để định nghĩa các route động
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case displayed_song:
      //   final args = settings.arguments as SongEntity;
      //   return MaterialPageRoute(
      //     builder: (context) =>
      //         SongPlayer(displayed_song: args, isnewSong: true),
      //   );
      default:
    }
    return null;
  }

  // Khai báo các route tĩnh
  static Map<String, WidgetBuilder> routes = {
    onBoarding: (context) => const OnboardingScreen(),
    signin: (context) => const SignInScreen(),
    signup: (context) => const SignUpScreen(),
    resetPassword: (context) => const ResetPasswordScreen(),
    newPassword: (context) => const NewPasswordScreen(),
    rootPage: (context) => const RootScreen()
  };
}
