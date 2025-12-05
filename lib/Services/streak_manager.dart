import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class StreakManager {
  static const String _lastOpenKey = 'last_open_date';
  static const String _streakCountKey = 'streak_count';
  static const String _notificationScheduledKey = 'notification_scheduled';

  // Check and update streak
  Future<Map<String, dynamic>> checkAndUpdateStreak() async {
    final prefs = await SharedPreferences.getInstance();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final lastOpenString = prefs.getString(_lastOpenKey);
    int currentStreak = prefs.getInt(_streakCountKey) ?? 0;

    if (lastOpenString == null) {
      // First time opening app
      currentStreak = 1;
      await prefs.setString(_lastOpenKey, today.toIso8601String());
      await prefs.setInt(_streakCountKey, currentStreak);
      await _scheduleStreakReminder();
      return {'streak': currentStreak, 'isNew': true};
    }

    final lastOpen = DateTime.parse(lastOpenString);
    final lastOpenDay = DateTime(lastOpen.year, lastOpen.month, lastOpen.day);
    final difference = today.difference(lastOpenDay).inDays;

    if (difference == 0) {
      // Same day - no change
      return {'streak': currentStreak, 'isNew': false};
    } else if (difference == 1) {
      // Next day - increment streak
      currentStreak++;
      await prefs.setString(_lastOpenKey, today.toIso8601String());
      await prefs.setInt(_streakCountKey, currentStreak);
      await _scheduleStreakReminder();
      await _showStreakContinuedNotification(currentStreak);
      return {'streak': currentStreak, 'isNew': true};
    } else {
      // Missed days - reset streak
      final brokenStreak = currentStreak;
      currentStreak = 1;
      await prefs.setString(_lastOpenKey, today.toIso8601String());
      await prefs.setInt(_streakCountKey, currentStreak);
      await _scheduleStreakReminder();
      await _showStreakBrokenNotification(brokenStreak);
      return {
        'streak': currentStreak,
        'isNew': false,
        'broken': true,
        'brokenStreak': brokenStreak
      };
    }
  }

  // Schedule daily reminder notification for the NEXT day.
  Future<void> _scheduleStreakReminder() async {
    // Cancel any previously scheduled streak reminders to avoid duplicates.
    await AwesomeNotifications().cancelSchedulesByChannelKey('streak_reminder');

    final String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    final DateTime tomorrow = DateTime.now().add(const Duration(days: 1));

    // Schedule a reminder for 8 PM tomorrow.
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'streak_reminder',
        title: '🔥 Don\'t break your streak!',
        body: 'Open EmotionEye to maintain your daily streak.',
        notificationLayout: NotificationLayout.Default,
        wakeUpScreen: true,
        category: NotificationCategory.Reminder,
        payload: {'type': 'streak_reminder'},
      ),
      schedule: NotificationCalendar(
        year: tomorrow.year,
        month: tomorrow.month,
        day: tomorrow.day,
        hour: 20,
        minute: 0,
        second: 0,
        timeZone: localTimeZone,
        repeats: false, // This is now a one-time notification
        allowWhileIdle: true,
        preciseAlarm: true,
      ),
    );

    // Schedule an urgent reminder for 10 PM tomorrow.
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2,
        channelKey: 'streak_reminder',
        title: '⚠️ Your streak is at risk!',
        body: 'Only 2 hours left! Open EmotionEye now to keep your streak alive.',
        notificationLayout: NotificationLayout.Default,
        wakeUpScreen: true,
        category: NotificationCategory.Alarm,
        payload: {'type': 'urgent_reminder'},
      ),
      schedule: NotificationCalendar(
        year: tomorrow.year,
        month: tomorrow.month,
        day: tomorrow.day,
        hour: 22,
        minute: 0,
        second: 0,
        timeZone: localTimeZone,
        repeats: false, // This is now a one-time notification
        allowWhileIdle: true,
        preciseAlarm: true,
      ),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationScheduledKey, true);
  }

  // Show streak continued notification
  Future<void> _showStreakContinuedNotification(int streak) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'streak_reminder',
        title: '🎉 Streak continued!',
        body: 'Amazing! You\'re on a $streak day streak. Keep it up!',
        notificationLayout: NotificationLayout.Default,
        payload: {'type': 'streak_continued', 'count': streak.toString()},
      ),
    );
  }

  // Show streak broken notification
  Future<void> _showStreakBrokenNotification(int brokenStreak) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 11,
        channelKey: 'streak_reminder',
        title: '💔 Streak broken!',
        body: 'You lost your $brokenStreak day streak. Let\'s start fresh!',
        notificationLayout: NotificationLayout.BigPicture,
        bigPicture: 'asset://assets/streak_broken.png', // Add your asset
        payload: {'type': 'streak_broken', 'count': brokenStreak.toString()},
      ),
    );
  }

  // Cancel all streak notifications
  Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAll();
  }

  // Get current streak count
  Future<int> getCurrentStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakCountKey) ?? 0;
  }

  // Reset streak manually
  Future<void> resetStreak() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_streakCountKey, 0);
    await prefs.remove(_lastOpenKey);
    await cancelAllNotifications();
  }

  // Check if streak will break soon
  Future<Duration> getTimeUntilStreakBreak() async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1, 0, 0, 0);
    return midnight.difference(now);
  }
}
