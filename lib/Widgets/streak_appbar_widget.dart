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
  int _streak = 0;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _loadStreak();
    _startClock();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadStreak() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _streak = prefs.getInt('streak_count') ?? 0;
    });
  }

  void _startClock() {
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemaining();
    });
  }

  void _updateRemaining() {
    final DateTime now = DateTime.now();
    final DateTime midnight =
    DateTime(now.year, now.month, now.day + 1);
    if (!mounted) return;
    setState(() {
      _remaining = midnight.difference(now);
    });
  }

  String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.inHours)}:${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade400, Colors.deepOrange.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 4),
          Text(
            '$_streak',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            height: 16,
            width: 1,
            color: Colors.white.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.timer_outlined, size: 14, color: Colors.white),
          const SizedBox(width: 3),
          Text(
            _format(_remaining),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
