import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/commons/storage_keys/auth.dart';
import 'package:trip_mate/core/ultils/generate_random_number.dart';
import 'package:trip_mate/features/security/data/dtos/new_pass_request.dart';

class SecurityApiSource {
  Future<Either> resetPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final prefs = await SharedPreferences.getInstance();
    int verifyKey = generateRandomNumber(min: 1000, max: 9999);
    logDebug(verifyKey.toString());
    await prefs.setString(AuthKeys.kAuthVerifyKey, verifyKey.toString());
    return Right("We've sent a password reset code to $email");
  }

  Future<Either> newPassword(NewPasswordRequest req) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const Right("We've changed your password");
  }
}