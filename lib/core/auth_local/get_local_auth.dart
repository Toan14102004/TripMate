import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trip_mate/core/ultils/toast_util.dart';

class GetLocalAuth {
  static LocalAuthentication auth = LocalAuthentication();

  static Future<bool> handleBiometricAuth() async {
    // Kiểm tra quyền sinh trắc học
    await Permission.sensors.request();
    var status = await Permission.sensors.status;
    if (!status.isGranted) {
      status = await Permission.sensors.request();
      if (!status.isGranted) {
        ToastUtil.showErrorToast('User denied permission to sensors.');
        return false;
      }
    }

    // Kiểm tra thiết bị có hỗ trợ không
    bool isSupported = await auth.isDeviceSupported();
    bool canCheckBiometrics = await auth.canCheckBiometrics;

    if (!isSupported || !canCheckBiometrics) {
      ToastUtil.showErrorToast('The device does not support biometric authentication.');
      return false;
    }

    // Bắt đầu xác thực
    bool authenticated = await auth.authenticate(
      localizedReason: 'Please authenticate to reset your password',
      options: const AuthenticationOptions(
        biometricOnly: true, // Có thể dùng mật khẩu nếu sinh trắc học thất bại
        stickyAuth: true,
      ),
    );

    if (authenticated) {
      ToastUtil.showSuccessToast('Successfully authenticated!');
      return true;
      // TODO: Gọi hàm reset mật khẩu ở đây
    } else {
      ToastUtil.showErrorToast('Authentication failed or was canceled.');
      return false;
    }
  }
}
