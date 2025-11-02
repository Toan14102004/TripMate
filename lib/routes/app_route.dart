import 'package:flutter/material.dart';
import 'package:trip_mate/features/auth/presentation/screens/signin_screen.dart';
import 'package:trip_mate/features/auth/presentation/screens/signup_screen.dart';
import 'package:trip_mate/features/auth/presentation/screens/verification_email_screen.dart';
import 'package:trip_mate/features/home/domain/models/tour_model.dart';
import 'package:trip_mate/features/home/presentation/screens/home_screen.dart';
import 'package:trip_mate/features/home/presentation/screens/package_detail_screen.dart';
import 'package:trip_mate/features/home/presentation/screens/popular_packages_screen.dart';
import 'package:trip_mate/features/home/presentation/screens/top_packages_screen.dart';
import 'package:trip_mate/features/my_trip/presentation/screens/my_trip_screen.dart';
import 'package:trip_mate/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:trip_mate/features/profile/presentation/screens/profile_screen.dart';
import 'package:trip_mate/features/root/presentation/screens/root_screen.dart';
import 'package:trip_mate/features/security/presentation/screens/new_password_screen.dart';
import 'package:trip_mate/features/security/presentation/screens/reset_password_screen.dart';
import 'package:trip_mate/features/wallet/presentation/screens/wallet_screen.dart';
class AppRoutes {
  // Route names
  static const String onboarding = '/onboarding';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String resetPassword = '/reset-password';
  static const String newPassword = '/new-password';
  static const String rootPage = '/root-page';
  static const String profilePage = '/profile-page';
  static const String verification = '/verification';
  static const String home = '/home';
  static const myTrip = '/my_trip';
  static const String settings = '/settings';
  static const String popularPackages = '/popular-packages';
  static const String packageDetail = '/package-detail';
  static const String tripDetail = '/trip-detail';
  static const String topPackages = '/top-packages';
  static const String wallet = '/wallets';
  // Route generator
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case packageDetail:
        final package = settings.arguments as TourModel;
        return MaterialPageRoute(
          builder: (context) => PackageDetailScreen(tour: package),
        );
      default:
        return null;
    }
  }

  // Static routes
  static Map<String, WidgetBuilder> routes = {
    onboarding: (context) => const OnboardingScreen(),
    signin: (context) => const SignInScreen(),
    signup: (context) => const SignUpScreen(),
    resetPassword: (context) => const ResetPasswordScreen(),
    newPassword: (context) => const NewPasswordScreen(),
    rootPage: (context) => const RootScreen(),
    home: (context) => const HomeScreen(),
    myTrip: (context) => const MyTripScreen(),
    popularPackages: (context) => const PopularPackagesScreen(),
    topPackages: (context) => const TopPackagesScreen(),
    profilePage: (context) => const ProfileScreen(),
    wallet: (context) => const WalletScreen(),
  };
}
