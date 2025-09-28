import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/commons/storage_keys/auth.dart';

Future<bool> checkSignIn() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  if (pref.getString(AuthKeys.kEmail) == null ||
      pref.getString(AuthKeys.kFullName) == null) {
    return false;
  }
  logDebug('${pref.getString(AuthKeys.kEmail)} +  ${pref.getString(AuthKeys.kFullName)}');
  return true;
}
