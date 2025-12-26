import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class StreakManager {
  static const String _lastOpenKey = 'last_open_date';
  static const String _streakCountKey = 'streak_count';

  // Public: check and update streak safely
  Future<Map<String, dynamic>> checkAndUpdateStreak() async {
    final prefs = await SharedPreferences.getInstance();

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    final String? lastOpenString = prefs.getString(_lastOpenKey);
    int currentStreak = prefs.getInt(_streakCountKey) ?? 0;

    if (lastOpenString == null) {
      currentStreak = 1;
      await _persist(today, currentStreak);
      await _scheduleTomorrowReminders();
      return {'streak': currentStreak, 'isNew': true};
    }

    final DateTime lastOpen = DateTime.parse(lastOpenString);
    final DateTime lastOpenDay =
    DateTime(lastOpen.year, lastOpen.month, lastOpen.day);

    final int dayDifference = today.difference(lastOpenDay).inDays;

    if (dayDifference == 0) {
      return {'streak': currentStreak, 'isNew': false};
    }

    if (dayDifference == 1) {
      currentStreak++;
      await _persist(today, currentStreak);
      await _scheduleTomorrowReminders();
      await _showStreakContinued(currentStreak);
      return {'streak': currentStreak, 'isNew': true};
    }

    final int brokenStreak = currentStreak;
    currentStreak = 1;
    await _persist(today, currentStreak);
    await _scheduleTomorrowReminders();
    await _showStreakBroken(brokenStreak);

    return {
      'streak': currentStreak,
      'isNew': false,
      'broken': true,
      'brokenStreak': brokenStreak,
    };
  }

  Future<void> _persist(DateTime day, int streak) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastOpenKey, day.toIso8601String());
    await prefs.setInt(_streakCountKey, streak);
  }

  // Always schedules for the *next* day to avoid duplicates
  Future<void> _scheduleTomorrowReminders() async {
    await AwesomeNotifications()
        .cancelSchedulesByChannelKey('streak_reminder');

    final String timeZone =
    await AwesomeNotifications().getLocalTimeZoneIdentifier();
    final DateTime tomorrow =
    DateTime.now().add(const Duration(days: 1));

    await _scheduleAt(
      id: 100,
      title: '🔥 Don\'t break your streak!',
      body: 'Open EmotionEye to keep your streak alive.',
      hour: 20,
      date: tomorrow,
      timeZone: timeZone,
    );

    await _scheduleAt(
      id: 101,
      title: '⚠️ Streak at risk!',
      body: 'Only 2 hours left! Open EmotionEye now.',
      hour: 22,
      date: tomorrow,
      timeZone: timeZone,
    );
  }

  Future<void> _scheduleAt({
    required int id,
    required String title,
    required String body,
    required int hour,
    required DateTime date,
    required String timeZone,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'streak_reminder',
        title: title,
        body: body,
        category: NotificationCategory.Reminder,
      ),
      schedule: NotificationCalendar(
        year: date.year,
        month: date.month,
        day: date.day,
        hour: hour,
        minute: 0,
        second: 0,
        timeZone: timeZone,
        repeats: false,
        preciseAlarm: true,
        allowWhileIdle: true,
      ),
    );
  }

  Future<void> _showStreakContinued(int streak) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 200,
        channelKey: 'streak_reminder',
        title: '🎉 Streak continued!',
        body: 'You are on a $streak day streak. Keep going!',
      ),
    );
  }

  Future<void> _showStreakBroken(int streak) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 201,
        channelKey: 'streak_reminder',
        title: '💔 Streak broken',
        body: 'You lost your $streak day streak. Start again today!',
      ),
    );
  }

  Future<int> getCurrentStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakCountKey) ?? 0;
  }

  Future<Duration> timeUntilMidnight() async {
    final DateTime now = DateTime.now();
    final DateTime midnight =
    DateTime(now.year, now.month, now.day + 1);
    return midnight.difference(now);
  }

  Future<void> resetStreak() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastOpenKey);
    await prefs.setInt(_streakCountKey, 0);
    await AwesomeNotifications().cancelSchedulesByChannelKey('streak_reminder');
  }
}
