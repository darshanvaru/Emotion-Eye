// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
//
// import '../Screens/main_camera.dart';
// import '../Screens/mood_improvement_dashboard.dart';
//
// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//
//   NotificationService._internal();
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   static const String _prefKeyNotificationEnabled = "notification_enabled";
//
//   Future<void> init() async {
//     // Initialize timezone data
//     tz.initializeTimeZones();
//
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const DarwinInitializationSettings initializationSettingsIOS =
//     DarwinInitializationSettings(
//       requestSoundPermission: true,
//       requestBadgePermission: true,
//       requestAlertPermission: true,
//     );
//
//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );
//
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
//     );
//
//     bool enabled = await isNotificationEnabled();
//     if (enabled) {
//       await scheduleDailyRandomNotifications();
//     }
//   }
//
//   void _onDidReceiveNotificationResponse(NotificationResponse response) {
//     String? payload = response.payload;
//     if (payload == null) return;
//
//     // This method needs a BuildContext to navigate, so navigation
//     // should be handled outside with the payload information.
//     // You can listen to this in your main widget or use a navigatorKey.
//   }
//
//   /// Call this from your app when you handle notification tap with a valid BuildContext
//   static void handleNotificationTap(BuildContext context, String payload) {
//     if (payload == 'detect') {
//       Navigator.push(
//           context, MaterialPageRoute(builder: (_) => MainCamera()));
//     } else if (payload == 'boost') {
//       Navigator.push(
//           context, MaterialPageRoute(builder: (_) => MoodImprovementDashboard(initialMood: 'happy',)));
//     }
//   }
//
//   Future<void> setNotificationEnabled(bool enabled) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool(_prefKeyNotificationEnabled, enabled);
//     if (enabled) {
//       await scheduleDailyRandomNotifications();
//     } else {
//       await cancelAllNotifications();
//     }
//   }
//
//   Future<bool> isNotificationEnabled() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool(_prefKeyNotificationEnabled) ?? true;
//   }
//
//   Future<void> cancelAllNotifications() async {
//     await flutterLocalNotificationsPlugin.cancelAll();
//   }
//
//   Future<void> scheduleDailyRandomNotifications() async {
//     bool enabled = await isNotificationEnabled();
//     if (!enabled) return;
//
//     await cancelAllNotifications();
//
//     final random = Random();
//
//     for (int id = 0; id < 3; id++) {
//       int hour = 8 + random.nextInt(13); // Between 8 and 20 inclusive
//       int minute = random.nextInt(60);
//       await _scheduleNotification(id, hour, minute);
//     }
//   }
//
//   Future<void> _scheduleNotification(int id, int hour, int minute) async {
//     final random = Random();
//     bool isDetect = random.nextBool();
//
//     String title;
//     String body;
//     String payload;
//
//     if (isDetect) {
//       title = "Time to check in!";
//       body = "Feel special and let’s detect your current emotion with a quick scan.";
//       payload = "detect";
//     } else {
//       title = "Boost your mood!";
//       body = "You deserve to feel amazing. Check out your personalized mood booster now!";
//       payload = "boost";
//     }
//
//     final androidDetails = AndroidNotificationDetails(
//       'emotioneye_channel_id',
//       'Emotion Eye Notifications',
//       channelDescription: 'Local notifications for EmotionEye app',
//       importance: Importance.max,
//       priority: Priority.high,
//       ticker: 'ticker',
//     );
//
//     final iosDetails = DarwinNotificationDetails();
//
//     final notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );
//
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       _nextInstanceOfTime(hour, minute),
//       notificationDetails,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//       payload: payload,
//     );
//   }
//
//   tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime scheduledDate =
//     tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
//     if (scheduledDate.isBefore(now)) {
//       scheduledDate = scheduledDate.add(const Duration(seconds: 30));
//     }
//     return scheduledDate;
//   }
// }
