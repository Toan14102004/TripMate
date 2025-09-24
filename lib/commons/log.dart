// Project: electric_cart_monitoring_app
// Copyright (c) 2024 M2M craft Co., Ltd.

import 'package:flutter/foundation.dart';

/// `logDebug` is a function that logs a debug message with a green heart emoji if
/// the app is running in debug mode. It prints the message surrounded by equal
/// signs for better visibility.
void logDebug(Object object) {
  if (kDebugMode) {
    print('💚 $object');
  }
}

/// `logError` is a function that logs an error message with a red heart emoji if
/// the app is running in debug mode. It prints the error message surrounded by
/// equal signs for better visibility.
void logError(Object object) {
  if (kDebugMode) {
    print('❤️ $object');
  }
}

/// `logWarning` is a function that logs a warning message with a yellow heart emoji
/// if the app is running in debug mode. It prints the warning message surrounded by
/// equal signs for better visibility.
void logWarning(Object object) {
  if (kDebugMode) {
    print('💛️ $object');
  }
}
