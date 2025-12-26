import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/mood_improvement_dashboard.dart';
import '../main.dart';
import '../screens/main_camera.dart';

class NotificationService {
  static const String _sentTodayKey = 'sentToday';
  static const String _lastDateKey = 'lastDate';
  static const int _dailyLimit = 3;

  static final Random _random = Random();

  static final List<String> boostMessages = [
    "Take a break! Boost your mood with something positive 😊",
    "A little positivity goes a long way! 🌟",
    "Smile! You're doing great! 😄",
    "Time for a mini dance break! 💃",
    "You deserve some happiness right now! ✨",
    "Boost your energy: Take a deep breath and smile! 😎",
    "Hey, remember to stay awesome today! 🌈",
    "Positive vibes only! Recharge your mood 💖",
    "You got this! Keep shining! 🌟",
    "Small joys make the biggest difference! ☀️"
  ];

  static final List<String> detectMessages = [
    "How are you feeling? Let’s detect your mood 📸",
    "Snap a quick selfie to see your mood today! 😎",
    "Check-in with your feelings, take a photo! 🖼️",
    "Curious how your mood is right now? Capture it! 🤳",
    "Time to see how you’re feeling inside! 🧠",
    "Mood check! Let EmotionEye do the magic ✨",
    "Let’s capture your current vibe! 🌈",
    "See what your expression reveals today 😄",
    "Your mood matters! Let’s check it out 📸",
    "Quick mood scan time! Ready? 🚀"
  ];

  static Future<void> initializeNotificationChannels() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: "notification_demo_key",
          channelKey: "notification_demo",
          channelName: "Notification Demo",
          channelDescription: "Demo for local notification",
          defaultColor: Colors.blue,
          importance: NotificationImportance.High,
          channelShowBadge: true,
        ),
        NotificationChannel(
          channelKey: 'streak_reminder',
          channelName: 'Streak Reminders',
          channelDescription: 'Daily streak reminder notifications',
          defaultColor: const Color(0xFFFF6D00),
          ledColor: Colors.orange,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: "notification_demo_key",
          channelGroupName: "Notification",
        ),
      ],
      debug: false,
    );
  }

  static Future<void> scheduleNextNotification() async {
    final prefs = await SharedPreferences.getInstance();
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    final DateTime lastDate =
        DateTime.tryParse(prefs.getString(_lastDateKey) ?? '') ?? today;
    int sentToday = prefs.getInt(_sentTodayKey) ?? 0;

    if (!_isSameDay(today, lastDate)) {
      sentToday = 0;
      await prefs.setInt(_sentTodayKey, 0);
      await prefs.setString(_lastDateKey, today.toIso8601String());
    }

    if (sentToday >= _dailyLimit) return;

    final DateTime scheduleTime = _generateFutureScheduleTime(now);
    final bool isBoost = _random.nextBool();

    final String message = isBoost
        ? boostMessages[_random.nextInt(boostMessages.length)]
        : detectMessages[_random.nextInt(detectMessages.length)];

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: _generateNotificationId(),
        channelKey: "notification_demo",
        title: "EmotionEye",
        body: message,
        payload: {'type': isBoost ? 'boost' : 'detect'},
      ),
      schedule: NotificationCalendar(
        year: scheduleTime.year,
        month: scheduleTime.month,
        day: scheduleTime.day,
        hour: scheduleTime.hour,
        minute: scheduleTime.minute,
        second: 0,
        millisecond: 0,
        repeats: false,
        allowWhileIdle: true,
        preciseAlarm: true,
      ),
    );

    await prefs.setInt(_sentTodayKey, sentToday + 1);
    await prefs.setString(_lastDateKey, today.toIso8601String());
  }

  static DateTime _generateFutureScheduleTime(DateTime now) {
    final int minDelayMinutes = 180;
    final int maxDelayMinutes = 360;
    final int delayMinutes =
        minDelayMinutes + _random.nextInt(maxDelayMinutes - minDelayMinutes);
    return now.add(Duration(minutes: delayMinutes));
  }

  static int _generateNotificationId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    await scheduleNextNotification();
  }

  static Future<void> onActionReceiveMethod(
      ReceivedAction receivedAction) async {
    final String? type = receivedAction.payload?['type'];

    if (type == 'boost') {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) =>
          const MoodImprovementDashboard(initialMood: 'happy'),
        ),
      );
    } else if (type == 'detect') {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => const MainCamera()),
      );
    }
  }

  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {}

  static Future<void> onDismissActionReceiveMethod(
      ReceivedAction receivedAction) async {}
}
