import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/commons/storage_keys/auth.dart';
import 'package:trip_mate/services/local_storage/auth.dart';

Future<bool> checkSignIn() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  if (await AuthRepository.getAccessToken() == null ||
      await AuthRepository.getRefreshToken() == null ) {
    return false;
  }
  logDebug('${pref.getString(AuthKeys.kEmail)}, ${await AuthRepository.getAccessToken()}, ${await AuthRepository.getRefreshToken()}');
  return true;
}
