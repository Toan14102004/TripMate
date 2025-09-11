import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trip_mate/core/app_global.dart';


class ToastUtil {
  static late FToast _fToast;
  static bool _isInitialized = false;

  /// Khởi tạo FToast với context từ NavigatorKey
  static void ensureInitialized() {
    if (_isInitialized) return;

    final context = AppGlobal.navigatorKey.currentContext;
    if (context != null) {
      init(context);
    }
  }

  static void init(BuildContext context) {
    _fToast = FToast();
    _fToast.init(context);
    _isInitialized = true;
  }

  static void showToast({
    required String message,
    String? title,
    Color backgroundColor = Colors.white,
    Color textColor = Colors.black87,
    Color borderColor = Colors.transparent,
    double fontSize = 14.0,
    ToastGravity gravity = ToastGravity.TOP,
    IconData? icon,
    Color? iconColor,
    int timeInSecForIosWeb = 2,
    Toast toastLength = Toast.LENGTH_SHORT,
    int milliseconds = 3000,
  }) {
    // Đảm bảo FToast đã được khởi tạo
    ensureInitialized();

    if (!_isInitialized) {
      // Fallback sử dụng Fluttertoast thông thường
      Fluttertoast.showToast(
        msg: message,
        toastLength: toastLength,
        gravity: gravity,
        timeInSecForIosWeb: timeInSecForIosWeb,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: fontSize,
      );
      return;
    }

    Widget toast = Container(
      width: 340,
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: fontSize + 2,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  message,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: textColor.withOpacity(0.8),
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    _fToast.showToast(
      child: toast,
      gravity: gravity,
      toastDuration: Duration(milliseconds: milliseconds),
    );
  }

  static void showSuccessToast(String message, {String? title}) {
    showToast(
      message: message,
      title: title ?? 'Success',
      backgroundColor: Colors.white,
      textColor: Colors.black87,
      borderColor: Colors.green.shade200,
      icon: Icons.check_circle_rounded,
      iconColor: Colors.green.shade600,
    );
  }

  static void showErrorToast(String message, {String? title}) {
    showToast(
      message: message,
      title: title ?? 'Error',
      backgroundColor: Colors.white,
      textColor: Colors.black87,
      borderColor: Colors.red.shade200,
      icon: Icons.error_rounded,
      iconColor: Colors.red.shade600,
    );
  }

  static void showWarningToast(String message, {String? title}) {
    showToast(
      message: message,
      title: title ?? 'Warning',
      backgroundColor: Colors.white,
      textColor: Colors.black87,
      borderColor: Colors.orange.shade200,
      icon: Icons.warning_amber_rounded,
      iconColor: Colors.orange.shade600,
    );
  }

  static void showInfoToast(String message, {String? title}) {
    showToast(
      message: message,
      title: title ?? 'Information',
      backgroundColor: Colors.white,
      textColor: Colors.black87,
      borderColor: Colors.blue.shade200,
      icon: Icons.info_rounded,
      iconColor: Colors.blue.shade600,
    );
  }
}
