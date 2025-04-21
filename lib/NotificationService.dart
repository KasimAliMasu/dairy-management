import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(android: androidInit);

    await _plugin.initialize(initSettings);

    // Request permissions (especially important on Android 13+ and iOS)
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'insemination_channel_id',
      'Insemination Channel',
      channelDescription: 'Notification after submitting insemination',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);
    await _plugin.show(0, title, body, details);
  }
}
