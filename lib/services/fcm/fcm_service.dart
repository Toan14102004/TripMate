import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/services/local_notification/local_notification_service.dart';

class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  // --- FCM ---
  StreamSubscription<RemoteMessage>? _messageSubscription;
  final StreamController<RemoteMessage> _messageController =
      StreamController<RemoteMessage>.broadcast();
  Stream<RemoteMessage> get messageStream => _messageController.stream;

  // --- Local Notification ---
  final LocalNotificationService _localNotif = LocalNotificationService();

  // --- Token ---
  String? _currentToken;
  String? get currentToken => _currentToken;

  // --- Server URL (thay bằng URL thật của bạn) ---
  final String _serverUrl = 'https://your-server.com/api/save-fcm-token';

  /// Khởi động toàn bộ: FCM + Local Notif + Token
  Future<void> startListening({
    required BuildContext context,
    required Function(RemoteMessage) onNotificationTapped,
    required String userId, // ID người dùng để server biết ai
  }) async {
    // 1. Khởi tạo Firebase (nếu chưa)
    await Firebase.initializeApp();

    // 2. Lấy và lưu token
    await _setupFCMToken(userId);

    // 3. Khởi tạo local notification
    await _localNotif.initialize(
      onSelectNotification: (payload) async {
        if (payload != null && context.mounted) {
          final data = jsonDecode(payload) as Map<String, dynamic>;
          final message = RemoteMessage(data: data);
          onNotificationTapped(message);
        }
      },
    );

    // 4. Lắng nghe foreground
    _messageSubscription = FirebaseMessaging.onMessage.listen((message) {
      print('FCM Foreground: ${message.messageId}');
      _messageController.add(message);
      _localNotif.showNotification(message);
    });

    // 5. Lắng nghe khi nhấn thông báo (background/terminated)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('FCM Opened: ${message.messageId}');
      _messageController.add(message);
      onNotificationTapped(message);
    });

    print('FCM Service Started + Token Saved');
  }

  /// Lấy token + lưu local + gửi server
  Future<void> _setupFCMToken(String userId) async {
    try {
      // Lấy token
      String? token;
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      for (int i = 0; i < 3; i++) {
        try {
          
          token = await FirebaseMessaging.instance.getToken();
          if (token != null) break;
        } catch (e) {
          await Future.delayed(Duration(seconds: 2));
        }
      }


      _currentToken = token;
      print('FCM Token: $token');

      // Lưu local (SharedPreferences)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', token ?? '');

      // Gửi lên server
      await _sendTokenToServer(token ?? '', userId);

      // Lắng nghe khi token thay đổi (refresh)
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        _currentToken = newToken;
        await prefs.setString('fcm_token', newToken);
        await _sendTokenToServer(newToken, userId);
        logDebug('FCM Token refreshed: $newToken');
      });
    } catch (e) {
      print('Lỗi lấy FCM token: $e');
    }
  }

  /// Gửi token lên server
  Future<void> _sendTokenToServer(String token, String userId) async {
    // try {
    //   final response = await http.post(
    //     Uri.parse(_serverUrl),
    //     headers: {'Content-Type': 'application/json'},
    //     body: jsonEncode({
    //       'userId': userId,
    //       'fcmToken': token,
    //       'platform': 'flutter', // optional
    //     }),
    //   );

    //   if (response.statusCode == 200) {
    //     print('Token gửi server thành công');
    //   } else {
    //     print('Lỗi gửi token: ${response.statusCode}');
    //   }
    // } catch (e) {
    //   print('Lỗi mạng khi gửi token: $e');
    // }
  }

  // --- Dừng & dọn dẹp ---
  void stopListening() {
    _messageSubscription?.cancel();
    _messageSubscription = null;
  }

  void dispose() {
    stopListening();
    _messageController.close();
  }
}