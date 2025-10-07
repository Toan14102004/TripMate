import 'package:flutter/material.dart';
import 'package:trip_mate/features/auth/presentation/screens/signin_screen.dart';
import 'package:trip_mate/features/auth/presentation/screens/signup_screen.dart';
import 'package:trip_mate/features/auth/presentation/screens/verification_screen.dart';
import 'package:trip_mate/features/home/presentation/screens/home_screen.dart';
import 'package:trip_mate/features/home/presentation/screens/package_detail_screen.dart';
import 'package:trip_mate/features/home/presentation/screens/popular_packages_screen.dart';
import 'package:trip_mate/features/home/presentation/screens/top_packages_screen.dart';
import 'package:trip_mate/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:trip_mate/features/settings/presentation/screens/settings_screen.dart';

import '../features/home/domain/models/tour_model.dart';

class AppRoutes {
  // Route names
  static const String onboarding = '/onboarding';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String verification = '/verification';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String popularPackages = '/popular-packages';
  static const String topPackages = '/top-packages';
  static const String packageDetail = '/package-detail';
  static String get profilePage => '/profile';
  static const String tripDetail = '/trip-detail';

  // Route generator
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case verification:
        final args = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => VerificationScreen(email: args),
        );
      case packageDetail:
        final package = settings.arguments as TourModel;
        return MaterialPageRoute(
          builder: (context) => PackageDetailScreen(package: package),
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
    home: (context) => const HomeScreen(),
    settings: (context) => const SettingsScreen(),
    popularPackages: (context) => const PopularPackagesScreen(),
    topPackages: (context) => const TopPackagesScreen(),
  };
}
