import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class StreakManager {
  static const _lastActiveDayKey = 'last_active_day';
  static const _streakCountKey = 'streak_count';

  /// Normalize to date-only (timezone safe)
  DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Must be called on app launch / resume
  Future<int> updateStreakIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();

    final today = _today();
    final lastDayStr = prefs.getString(_lastActiveDayKey);
    int streak = prefs.getInt(_streakCountKey) ?? 0;

    if (lastDayStr == null) {
      // First ever open
      streak = 1;
    } else {
      final lastDay = DateTime.parse(lastDayStr);
      final diff = today.difference(lastDay).inDays;

      if (diff == 1) {
        streak += 1; // continued
        await _notifyStreakContinued(streak);
      } else if (diff > 1) {
        await _notifyStreakBroken(streak);
        streak = 1; // reset
      }
      // diff == 0 → same day, do nothing
    }

    await prefs.setString(_lastActiveDayKey, today.toIso8601String());
    await prefs.setInt(_streakCountKey, streak);

    await _scheduleTomorrowReminder();

    return streak;
  }

  Future<int> getCurrentStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakCountKey) ?? 0;
  }

  /* ---------------- Notifications ---------------- */

  Future<void> _scheduleTomorrowReminder() async {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1, 20);

    final id = DateTime.now().millisecondsSinceEpoch & 0x7FFFFFFF;

    await AwesomeNotifications().cancelSchedulesByChannelKey('streak_reminder');

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'streak_reminder',
        title: '🔥 Keep your streak alive!',
        body: 'Open Emotion Eye today to continue your streak.',
        category: NotificationCategory.Reminder,
      ),
      schedule: NotificationCalendar.fromDate(
        date: tomorrow,
        preciseAlarm: true,
        allowWhileIdle: true,
      ),
    );
  }

  Future<void> _notifyStreakContinued(int streak) async {
    final id = DateTime.now().millisecondsSinceEpoch & 0x7FFFFFFF;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'streak_reminder',
        title: '🎉 Streak continued!',
        body: 'You are on a $streak day streak. Keep going!',
      ),
    );
  }

  Future<void> _notifyStreakBroken(int previous) async {
    if (previous <= 0) return;

    final id = DateTime.now().millisecondsSinceEpoch & 0x7FFFFFFF;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'streak_reminder',
        title: '💔 Streak broken',
        body: 'Your $previous day streak ended. Start again today!',
      ),
    );
  }
}
