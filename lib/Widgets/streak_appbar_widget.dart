import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreakAppBarWidget extends StatefulWidget {
  const StreakAppBarWidget({super.key});

  @override
  State<StreakAppBarWidget> createState() => _StreakAppBarWidgetState();
}

class _StreakAppBarWidgetState extends State<StreakAppBarWidget> {
  Timer? _timer;
  int _currentStreak = 0;
  Duration _timeRemaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _loadStreakData();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadStreakData() async {
    final prefs = await SharedPreferences.getInstance();
    final streak = prefs.getInt('streak_count') ?? 0;

    if (mounted) {
      setState(() {
        _currentStreak = streak;
      });
    }
  }

  void _startTimer() {
    _updateTimeRemaining();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTimeRemaining();
    });
  }

  void _updateTimeRemaining() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1, 0, 0, 0);
    final difference = midnight.difference(now);

    if (mounted) {
      setState(() {
        _timeRemaining = difference;
      });
    }
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade400, Colors.deepOrange.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🔥', style: TextStyle(fontSize: 18)),
          SizedBox(width: 4),
          Text(
            '$_currentStreak',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 6),
          Container(
            height: 16,
            width: 1,
            color: Colors.white.withOpacity(0.5),
          ),
          SizedBox(width: 6),
          Icon(Icons.timer_outlined, color: Colors.white, size: 14),
          SizedBox(width: 3),
          Text(
            _formatTime(_timeRemaining),
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              fontFeatures: [
                FontFeature.tabularFigures()
              ], // Fixed: plural "fontFeatures"
            ),
          ),
        ],
      ),
    );
  }
}
