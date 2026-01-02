import 'dart:async';
import 'package:flutter/material.dart';
import '../Services/streak_manager.dart';

class StreakAppBarWidget extends StatefulWidget {
  const StreakAppBarWidget({super.key});

  @override
  State<StreakAppBarWidget> createState() => _StreakAppBarWidgetState();
}

class _StreakAppBarWidgetState extends State<StreakAppBarWidget> {
  final StreakManager _manager = StreakManager();
  int _streak = 0;
  Duration _remaining = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _refresh();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    final streak = await _manager.getCurrentStreak();
    if (mounted) {
      setState(() => _streak = streak);
    }
  }

  void _startCountdown() {
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    setState(() => _remaining = midnight.difference(now));
  }

  String _fmt(Duration d) =>
      '${d.inHours.toString().padLeft(2, '0')}:'
          '${(d.inMinutes % 60).toString().padLeft(2, '0')}:'
          '${(d.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade400, Colors.deepOrange.shade600],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Text('🔥'),
          const SizedBox(width: 6),
          Text(
            '$_streak',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _fmt(_remaining),
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
